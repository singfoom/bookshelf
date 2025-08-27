require "test_helper"

class Admin::BooksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @user = users(:john)
    @book = books(:one)
    @author = authors(:one)
  end

  test "should require login to access admin books" do
    get admin_books_path
    assert_redirected_to login_path
    assert_equal "You must be logged in to access this page.", flash[:alert]
  end

  test "should require admin privileges to access books" do
    log_in_as(@user)
    get admin_books_path
    assert_redirected_to root_path
    assert_equal "Access denied. Admin privileges required.", flash[:alert]
  end

  test "should get index for admin" do
    log_in_as(@admin)
    get admin_books_path
    assert_response :success
    assert_select "h1", "Books Administration"
  end

  test "should show book for admin" do
    log_in_as(@admin)
    get admin_book_path(@book)
    assert_response :success
    assert_select "h1", @book.title
  end

  test "should get new for admin" do
    log_in_as(@admin)
    get new_admin_book_path
    assert_response :success
    assert_select "h1", "New Book"
  end

  test "should create book for admin" do
    log_in_as(@admin)
    assert_difference('Book.count', 1) do
      post admin_books_path, params: { 
        book: { 
          title: "New Test Book", 
          genre: "Test Genre", 
          author_id: @author.id 
        } 
      }
    end
    assert_redirected_to admin_book_path(Book.last)
    assert_equal "Book was successfully created.", flash[:notice]
  end

  test "should not create book with invalid data" do
    log_in_as(@admin)
    assert_no_difference('Book.count') do
      post admin_books_path, params: { 
        book: { 
          title: "", 
          genre: "", 
          author_id: "" 
        } 
      }
    end
    assert_response :unprocessable_content
  end

  test "should get edit for admin" do
    log_in_as(@admin)
    get edit_admin_book_path(@book)
    assert_response :success
    assert_select "h1", "Edit Book: #{@book.title}"
  end

  test "should update book for admin" do
    log_in_as(@admin)
    patch admin_book_path(@book), params: { 
      book: { 
        title: "Updated Title",
        genre: @book.genre,
        author_id: @book.author_id
      } 
    }
    assert_redirected_to admin_book_path(@book)
    assert_equal "Book was successfully updated.", flash[:notice]
    @book.reload
    assert_equal "Updated Title", @book.title
  end

  test "should not update book with invalid data" do
    log_in_as(@admin)
    patch admin_book_path(@book), params: { 
      book: { 
        title: "",
        genre: @book.genre,
        author_id: @book.author_id
      } 
    }
    assert_response :unprocessable_content
  end

  test "should destroy book for admin" do
    log_in_as(@admin)
    assert_difference('Book.count', -1) do
      delete admin_book_path(@book)
    end
    assert_redirected_to admin_books_path
    assert_equal "Book was successfully deleted.", flash[:notice]
  end

  test "should deny access to non-admin user for all actions" do
    log_in_as(@user)
    
    get admin_books_path
    assert_redirected_to root_path
    
    get admin_book_path(@book)
    assert_redirected_to root_path
    
    get new_admin_book_path
    assert_redirected_to root_path
    
    post admin_books_path, params: { book: { title: "Test" } }
    assert_redirected_to root_path
    
    get edit_admin_book_path(@book)
    assert_redirected_to root_path
    
    patch admin_book_path(@book), params: { book: { title: "Test" } }
    assert_redirected_to root_path
    
    delete admin_book_path(@book)
    assert_redirected_to root_path
  end

  private

  def log_in_as(user)
    post login_path, params: { email: user.email, password: user.admin? ? 'admin123' : 'password123' }
  end
end