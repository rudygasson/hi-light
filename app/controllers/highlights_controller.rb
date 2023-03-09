class HighlightsController < ApplicationController

  before_action :set_highlight, only: ['destroy']

  def index
    @highlights = Highlight.all
  end

  def destroy
    @highlight.destroy
    redirect_to book_path(book)
  end

  def import
    # @highlights = Highlight.all
  end

  # TODO: Refactor and simplify
  def upload
    raise
    @text = params[:file].tempfile.read
    @highlights = generate_highlights(@text)

    @highlights.each do |item|

      # Check if author exists, otherwise create
      # TODO: use find_by
      author = Author.new(name: item[:author])


      author = Author.where(name: item[:author])
      if author.present?
        author = author.first
      else
        author = Author.create(name: item[:author])
      end

      # Check if book exists, otherwise create
      # TODO: Check only for books by same author!
      book = Book.where(title: item[:title], author: author)
      if book.present?
        book = book.first
      else
        book = Book.create(title: item[:title], author: author)
      end

      # Create highlight
      # TODO: Check for duplicates
      # TODO: Check "Your Bookmark/Note/Highlight"
      # TODO: Fix bug where author can be empty
      highlight = Highlight.create(
        user: current_user,
        book: book,
        quote: item[:quote],
        page: item[:page],
        location_start: item[:location_start],
        location_end: item[:location_end],
        highlight_date: item[:date]
      )
    end

  end

  private

  def set_highlight
    @highlight = Highlight.find(params[:id])
  end

  # def save_uploaded_file(uploaded_file)
  #   File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename), 'wb') do |file|
  #     file.write(uploaded_file.read)
  #   end
  # end

  def generate_highlights(source)
    highlights = []
    clippings = source.split('==========')
    clippings.each do |clipping|
      clipping.strip!
      next if clipping == ""

      highlights << parse_clipping(clipping)
    end
    highlights
  end

  # TODO: Create hash in one go
  def parse_clipping(clipping)
    highlight = {}

    # Separate lines of the clipping
    lines = clipping.split("\n")

    # First line contains book title and author
    regex_title_author = /(?<title>[\S ]+) \((?<author>[^(]+)\)/
    title_author = lines[0].match(regex_title_author)
    # Second line contains metadata (page number, character location, highlighting date)
    regex_metadata = /Your (?<type>\w+) on page (?<page>\d*) \| location (?<location_start>\d+)-?(?<location_end>\d*) \| Added on (?<date>[\S ]*)/
    metadata = lines[1].match(regex_metadata)
    # Third line is empty, fourth line contains the text highlight
    highlight[:quote] = lines[3].strip unless lines[3].nil?

    # Return a hash representing the highlight
    highlight[:title] = title_author[:title]
    highlight[:author] = title_author[:author]
    highlight[:type] = metadata[:type]
    highlight[:page] = metadata[:page]
    highlight[:location_start] = metadata[:location_start]
    highlight[:location_end] = metadata[:location_end]
    highlight[:date] = metadata[:date]
    return highlight
  end
end
