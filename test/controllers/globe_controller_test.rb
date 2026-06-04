require "test_helper"

class GlobeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get globe_index_url
    assert_response :success
  end
end
