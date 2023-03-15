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
    if @hi_tag.save
      redirect_back_or_to highlights_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @hi_tag = HiTag.find(params[:id])
    @hi_tag.destroy
    redirect_back_or_to highlights_path
  end
end
