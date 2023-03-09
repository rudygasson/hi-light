class HighlightsController < ApplicationController
  before_action :set_highlight, only: ['destroy']

  def index
    @highlights = Highlight.all
  end

  def destroy
    @highlight.destroy
    redirect_to book_path(book)
  end

  private

  def set_highlight
    @highlight = Highlight.find(params[:id])
  end
end
