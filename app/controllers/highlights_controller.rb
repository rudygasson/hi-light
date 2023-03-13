class HighlightsController < ApplicationController
  before_action :set_highlight, only: ['destroy']

  def index
    if params[:query].present?
      sql_query = <<~SQL
        highlights.quote @@ :query
      SQL
      @highlights = Highlight
        .where(sql_query, query: "%#{params[:query]}%")
        .and(Highlight.where(user: current_user))
    else
      @highlights = Highlight.where(user: current_user)
    end
  end

  def destroy
    @highlight.destroy
    redirect_to book_path(@highlight.book)
  end

  def import
  end

  def upload
    if params[:file].nil?
      @message = "Please select a file to import."
    else
      source = File.read(params[:file].tempfile, encoding: "utf-8")

      # Initialise tracking of duplicates and imported records
      @imported = []
      @duplicates = []

      # Generate highlights from source
      @highlights = generate_highlights(source)
      @highlights.each do |highlight|

        # Check if author exists, otherwise create
        author = Author.find_by(name: highlight[:author])
        author = Author.create(name: highlight[:author]) if author.blank?

        # Check if book exists, otherwise create
        book = Book.find_by(title: highlight[:title], author: author, user: current_user)
        book = Book.create(title: highlight[:title], author: author, user: current_user) if book.blank?

        # Check if highlight exists, otherwise create, track duplicates
        if Highlight.exists?(user: current_user, book: book, quote: highlight[:quote])
          @duplicates << highlight
          next
        end

        Highlight.create(
          user: current_user,
          book: book,
          quote: highlight[:quote],
          page: highlight[:page],
          location_start: highlight[:location_start],
          location_end: highlight[:location_end],
          highlight_date: highlight[:highlight_date]
        )
      end
    end
  end

  private

  def set_highlight
    @highlight = Highlight.find(params[:id])
  end

  def generate_highlights(source)
    highlights = []
    # Remove whitespace and split source text into individual clippings
    strip_whitespace!(source).split('==========').each do |clipping|
      clipping.strip!
      # Ignore empty clippings
      next if clipping == ""

      highlight = parse_clipping(clipping)
      # Ignore non-Highlights (Notes and Bookmarks)
      next if %w[Note Bookmark].include?(highlight[:type])

      highlights << highlight
    end
    # Return an array of highlight hashes
    highlights
  end

  def strip_whitespace!(string)
    # Strip non-width whitespaces, requires utf-8 encoding
    string.gsub(/[\ufeff\u200b\u200d]/, "")
  end

  def parse_clipping(clipping)
    # Separate lines of the clipping
    lines = clipping.split("\n")
    # First line contains book title and author
    regex_title_author = /(?<title>[\S ]+) (?:- (?<author_alt>[\w ]+)|\((?<author>[^(]+)\))/
    # regex_title_author = /(?<title>[\S ]+) \((?<author>[^(]+)\)/
    title_author = lines[0].match(regex_title_author)
    # Second line contains metadata (page number, character location, highlighting date)
    regex_metadata = /Your (?<type>\w+) on page (?<page>\d*)-?(?:\d*)(?: \| location (?<location_start>\d+)-?(?<location_end>\d*))? \| Added on (?<date>[\S ]*)/
    metadata = lines[1].match(regex_metadata)
    # Third line is empty, fourth line contains the text highlight
    # Return a hash representing the highlight
    {
      title: title_author[:title]&.strip,
      author: (title_author[:author]||title_author[:author_alt])&.strip,
      type: metadata[:type]&.strip,
      page: metadata[:page]&.strip,
      location_start: metadata[:location_start]&.strip,
      location_end: metadata[:location_end]&.strip,
      highlight_date: metadata[:date]&.strip,
      quote: lines[3]&.strip
    }
  end

  def assign_random_cover
    num = ('%02d' % (1..16).to_a.sample)
    color = "orange"
    "cover-#{num}-#{color}.png"
  end
end
