# encoding: utf-8

class HighlightsController < ApplicationController
  before_action :set_highlight, only: ['destroy']

  def index
    @highlights = Highlight.all
  end

  def destroy
    @highlight.destroy
    redirect_to book_path(@highlight.book)
  end

  def import
  end

  def upload
    source = File.read(params[:file].tempfile, encoding: "utf-8")
    @highlights = generate_highlights(source)
    @highlights.each do |item|
      # Check if author exists, otherwise create
      # TODO: use find_by
      author = Author.where(name: item[:author])
      if author.present?
        author = author.first
      else
        author = Author.create(name: item[:author])
      end

      # Check if book exists, otherwise create
      book = Book.where(title: item[:title], author: author, user: current_user)
      if book.present?
        book = book.first
      else
        book = Book.create(title: item[:title], author: author, user: current_user)
      end

      # Create highlight
      # TODO: Check for duplicates
      # TODO: Check "Your Bookmark/Note/Highlight"
      # TODO: Fix bug where author can be empty
      Highlight.create(
        user: current_user,
        book: book,
        quote: item[:quote],
        page: item[:page],
        location_start: item[:location_start],
        location_end: item[:location_end],
        highlight_date: item[:highlight_date]
      )
    end
  end

  private

  def set_highlight
    @highlight = Highlight.find(params[:id])
  end

  def generate_highlights(source)
    highlights = []
    strip_whitespace!(source).split('==========').each do |clipping|
      clipping.strip!
      next if clipping == ""

      highlights << parse_clipping(clipping)
    end
    highlights
  end

  def strip_whitespace!(string)
    # Strip non-width whitespaces
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
end
