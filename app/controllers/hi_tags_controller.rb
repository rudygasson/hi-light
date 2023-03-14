class HiTagsController < ApplicationController
  def new
    @highlight = Highlight.find(params[:highlight_id])
    @tags = Tag.where(user: current_user)
    @hi_tag = HiTag.new
  end

  def create
    @hi_tag = HiTag.new
    @tag = Tag.find(params[:hi_tag][:tag])
    @highlight = Highlight.find(params[:highlight_id])
    @hi_tag = HiTag.new(tag: @tag, highlight: @highlight)
    @hi_tag.save
    #   redirect_to highlight_path(highlight, book: @book)
    # else
    #   render :new, status: :unprocessable_entity
    # end
  end
end
