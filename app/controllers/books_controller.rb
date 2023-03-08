class BooksController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def show
    @book = Book.find(params[:id])
  end
  
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
