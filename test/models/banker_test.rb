require "test_helper"

class BankerTest < ActiveSupport::TestCase
  def setup
    @banker = bankers(:one)
  end

  test "invalid banker is invalid" do
    banker = Banker.new
    refute banker.valid? 
  end

  test "valid banker is valid" do
    assert @banker.valid? 
  end

  test "banker without user_id is invalid" do
    @banker.user_id = nil
    refute @banker.valid?
  end

  test "banker without simple_success is invalid" do
    @banker.simple_success = nil
    refute @banker.valid?
  end

  test "banker's simple success must be an integer" do
    @banker.simple_success = 'not_number'
    refute @banker.valid?
  end

  test "banker can add one point to simple success" do
    @banker.add_simple_point
    assert_equal 1,  @banker.simple_success
  end

  test "banker can lose a point for simple success" do
    @banker.subtract_simple_point
    assert_equal -1, @banker.simple_success
  end

  test "simple_positive returns true if simple_success is positive" do
    assert @banker.simple_positive?
  end

  test "simple_negative returns true if simple_success is negative" do
    @banker.subtract_simple_point
    assert @banker.simple_negative?
  end

end
