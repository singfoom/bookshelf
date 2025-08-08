class HomeController < ApplicationController
  def index
    @authors_count = Author.count
    @books_count = Book.count
    @recent_books = Book.includes(:author).order(created_at: :desc).limit(5)
  end
end
