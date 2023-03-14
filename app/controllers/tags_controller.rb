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
      @search_tags = Tag.where(sql_query, query: "%#{params[:query]}%")
        .and(Tag.where(user: current_user)).map { |tag| tag.id }

        @highlights = HiTag.all.select { |hitag| @search_tags.include?(hitag.tag_id) }.map { |hitag| hitag.highlight }

      # @highlights = Highlight.all.select { |highlight| highlight.id ==  }
      #@search_tags.first.highlights
    else
      @highlights = nil
    end
  end

  # def index
  #   if params[:query].present?
  #     sql_query = <<~SQL
  #     books.title @@ :query
  #     OR authors.name @@ :query
  #     SQL
  #     @books = Book.joins(:author).where(sql_query, query: "%#{params[:query]}%", user: current_user)
  #   else
  #     @books = Book.includes(:author).where(user: current_user)
  #   end
  # end

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

  def destroy_all
    @tags = Tag.where(tag.highlights.empty?).destroy_all
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
