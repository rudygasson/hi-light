class BooksController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]
  before_action :set_book, only: ['update']

  def index
    if params[:query].present?
      sql_query = <<~SQL
      books.title @@ :query
      OR authors.name @@ :query
      SQL
      @books = Book.joins(:author).where(sql_query, query: "%#{params[:query]}%")
    else
      @books = Book.all
    end
  end

  def show
    @book = Book.find(params[:id])
    if params[:query].present?
      sql_query = <<~SQL
        highlights.quote @@ :query
      SQL
      @highlights = @book.highlights.where(sql_query, query: "%#{params[:query]}%")
    else
      @highlights = @book.highlights
    end
  end

  def update
    @book.update(books_params)
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def books_params
    params.require(:books).permit(:position)
  end
end
