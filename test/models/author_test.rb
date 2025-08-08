require "test_helper"

class AuthorTest < ActiveSupport::TestCase
  def setup
    @author = authors(:one)
  end

  test "should be valid with valid attributes" do
    assert @author.valid?
  end

  test "should require first_name" do
    @author.first_name = nil
    assert_not @author.valid?
    assert_includes @author.errors[:first_name], "can't be blank"
  end

  test "should require last_name" do
    @author.last_name = nil
    assert_not @author.valid?
    assert_includes @author.errors[:last_name], "can't be blank"
  end

  test "should not be valid with blank first_name" do
    @author.first_name = ""
    assert_not @author.valid?
    assert_includes @author.errors[:first_name], "can't be blank"
  end

  test "should not be valid with blank last_name" do
    @author.last_name = ""
    assert_not @author.valid?
    assert_includes @author.errors[:last_name], "can't be blank"
  end

  test "full_name should return combined first and last name" do
    assert_equal "Jane Austen", @author.full_name
  end

  test "full_name should handle names with extra spaces" do
    @author.first_name = " John "
    @author.last_name = " Doe "
    assert_equal "John   Doe", @author.full_name.strip
  end

  test "should have many books" do
    assert_respond_to @author, :books
  end

  test "should have associated books from fixtures" do
    jane_austen = authors(:one)
    assert_includes jane_austen.books, books(:one)
    assert_includes jane_austen.books, books(:three)
    assert_equal 2, jane_austen.books.count
  end

  test "should destroy associated books when author is destroyed" do
    author = authors(:one)
    book_ids = author.books.pluck(:id)

    assert_difference "Book.count", -2 do
      author.destroy
    end

    book_ids.each do |id|
      assert_nil Book.find_by(id: id)
    end
  end

  test "should create new author with valid attributes" do
    assert_difference "Author.count", 1 do
      Author.create!(
        first_name: "Harper",
        last_name: "Lee"
      )
    end
  end
end
