class HighlightsController < ApplicationController
  def index
    @highlights = Highlight.all
  end
end
