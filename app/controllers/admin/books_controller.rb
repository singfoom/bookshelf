class Admin::BooksController < Admin::AdminController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.includes(:author).order(:title)
  end

  def show
  end

  def new
    @book = Book.new
    @authors = Author.order(:first_name, :last_name)
  end

  def create
    @book = Book.new(book_params)
    @authors = Author.order(:first_name, :last_name)

    if @book.save
      redirect_to admin_book_path(@book), notice: "Book was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @authors = Author.order(:first_name, :last_name)
  end

  def update
    @authors = Author.order(:first_name, :last_name)

    if @book.update(book_params)
      redirect_to admin_book_path(@book), notice: "Book was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @book.destroy
    redirect_to admin_books_path, notice: "Book was successfully deleted."
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :genre, :author_id)
  end
end