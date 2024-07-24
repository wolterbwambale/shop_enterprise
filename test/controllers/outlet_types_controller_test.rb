require "test_helper"

class OutletTypesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get outlet_types_index_url
    assert_response :success
  end

  test "should get show" do
    get outlet_types_show_url
    assert_response :success
  end
end
