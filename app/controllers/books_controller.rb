class BooksController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]
  before_action :set_book, only: ['destroy', 'edit', 'update', 'set_parsed_cover', 'random_cover', 'friends_show']

  def index
    if params[:query].present?
      sql_query = <<~SQL
      books.title @@ :query
      OR authors.name @@ :query
      SQL
      @books = Book.joins(:author)
        .where(sql_query, query: "%#{params[:query]}%") # TODO: REWORK AND current user
    else
      @books = Book.includes(:author).where(user: current_user)
      flash.now[:notice] = "You have exactly #{@books.size} books in your library."
    end
  end

  def show
    @book = Book.find(params[:id])
    if params[:query].present?
      sql_query = <<~SQL
        highlights.quote @@ :query
      SQL
      @highlights = @book.highlights
        .where(sql_query, query: "%#{params[:query]}%")
    else
      @highlights = @book.highlights
    end
  end

  def friends_show
  end

  def edit
  end

  def update
    @book.update(book_params)
    redirect_to user_path(current_user)
  end

  def destroy
    @book.destroy
    redirect_to user_path(current_user)
  end

  def set_parsed_cover
    @book.parse_cover
    @book.save
    redirect_to book_path(@book)
  end

  def random_cover
    @book.cover.purge
    @book.set_default_cover
    @book.save
    redirect_to book_path(@book)
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

  def book_params
    params.require(:book).permit(:cover)
  end
end
