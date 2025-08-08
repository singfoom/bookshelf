require "test_helper"

class BookTest < ActiveSupport::TestCase
  def setup
    @book = books(:one)
    @author = authors(:one)
  end

  test "should be valid with valid attributes" do
    assert @book.valid?
  end

  test "should require title" do
    @book.title = nil
    assert_not @book.valid?
    assert_includes @book.errors[:title], "can't be blank"
  end

  test "should require genre" do
    @book.genre = nil
    assert_not @book.valid?
    assert_includes @book.errors[:genre], "can't be blank"
  end

  test "should require author" do
    @book.author = nil
    assert_not @book.valid?
    assert_includes @book.errors[:author], "must exist"
  end

  test "should not be valid with blank title" do
    @book.title = ""
    assert_not @book.valid?
    assert_includes @book.errors[:title], "can't be blank"
  end

  test "should not be valid with blank genre" do
    @book.genre = ""
    assert_not @book.valid?
    assert_includes @book.errors[:genre], "can't be blank"
  end

  test "should belong to author" do
    assert_respond_to @book, :author
  end

  test "should have correct author association" do
    assert_equal @author, @book.author
    assert_equal "Jane Austen", @book.author.full_name
  end

  test "should create new book with valid attributes and author" do
    assert_difference "Book.count", 1 do
      Book.create!(
        title: "To Kill a Mockingbird",
        genre: "Fiction",
        author: @author
      )
    end
  end

  test "should not create book without author" do
    assert_no_difference "Book.count" do
      assert_raises ActiveRecord::RecordInvalid do
        Book.create!(
          title: "Some Book",
          genre: "Some Genre",
          author: nil
        )
      end
    end
  end

  test "should have author_id as foreign key" do
    assert_equal @author.id, @book.author_id
  end

  test "book should be destroyed when referenced by author" do
    book_id = @book.id
    @author.destroy
    assert_nil Book.find_by(id: book_id)
  end

  test "should be able to change author" do
    new_author = authors(:two)
    @book.author = new_author
    assert @book.valid?
    @book.save!
    @book.reload
    assert_equal new_author, @book.author
    assert_equal "George Orwell", @book.author.full_name
  end
end
