require 'test_helper'

class Admin::BuildsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_build = admin_builds(:one)
  end

  test "should get index" do
    get admin_builds_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_build_url
    assert_response :success
  end

  test "should create admin_build" do
    assert_difference('Admin::Build.count') do
      post admin_builds_url, params: { admin_build: {  } }
    end

    assert_redirected_to admin_build_url(Admin::Build.last)
  end

  test "should show admin_build" do
    get admin_build_url(@admin_build)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_build_url(@admin_build)
    assert_response :success
  end

  test "should update admin_build" do
    patch admin_build_url(@admin_build), params: { admin_build: {  } }
    assert_redirected_to admin_build_url(@admin_build)
  end

  test "should destroy admin_build" do
    assert_difference('Admin::Build.count', -1) do
      delete admin_build_url(@admin_build)
    end

    assert_redirected_to admin_builds_url
  end
end
