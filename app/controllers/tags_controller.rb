class TagsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_tag, only: [:edit, :update, :destroy, :destroy_all]

  def index
    @tags = Tag.where(user: current_user)
    if params[:query].present?
      sql_query = <<~SQL
        tags.name @@ :query
        OR tags.name ILIKE :query
      SQL
      search_tags = Tag.where(sql_query, query: "%#{params[:query]}%").and(Tag.where(user: current_user)).pluck(:name)
      @highlights = Highlight.joins(:tags).where(tags: { name: search_tags }).and(Highlight.where(user: current_user)).distinct
    else
      @highlights = nil
    end
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.user = current_user
    if @tag.save
      redirect_to tags_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @tag.update(tag_params)

    respond_to do |format|
      format.html { redirect_to tags_manage_path }
      format.text { render partial: "tags/tag-infos", locals: {tag: @tag}, formats: [:html] }
    end
  end

  def destroy
    @tag.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :color)
  end
end
