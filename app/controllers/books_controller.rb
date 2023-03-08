class BooksController < ApplicationController
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
end
