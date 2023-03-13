class TagsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_tag, only: [:edit, :update, :destroy]

  def index
    if params[:query].present?
      sql_query = <<~SQL
        tags.name @@ :query
      SQL
      @tags = Tag.where(sql_query, query: "%#{params[:query]}%")
    else
      @tags = nil
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
    redirect_to tags_path
  end

  def destroy
    @tag.destroy
    redirect_to tags_path, status: :see_other
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :color)
  end
end
