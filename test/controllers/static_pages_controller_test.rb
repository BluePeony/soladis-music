require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get in_kuerze" do
    get static_pages_in_kuerze_url
    assert_response :success
  end

  test "should get ueber-mich" do
    get static_pages_ueber-mich_url
    assert_response :success
  end

  test "should get impressum" do
    get static_pages_impressum_url
    assert_response :success
  end

  test "should get datenschutz" do
    get static_pages_datenschutz_url
    assert_response :success
  end

  test "should get kontakt" do
    get static_pages_kontakt_url
    assert_response :success
  end
end
