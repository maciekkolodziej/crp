require 'test_helper'

class DatabaseResetsControllerTest < ActionController::TestCase
  setup do
    @database_reset = database_resets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:database_resets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create database_reset" do
    assert_difference('DatabaseReset.count') do
      post :create, database_reset: { created_at: @database_reset.created_at, hostname: @database_reset.hostname, ip: @database_reset.ip, updated_at: @database_reset.updated_at }
    end

    assert_redirected_to database_reset_path(assigns(:database_reset))
  end

  test "should show database_reset" do
    get :show, id: @database_reset
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @database_reset
    assert_response :success
  end

  test "should update database_reset" do
    patch :update, id: @database_reset, database_reset: { created_at: @database_reset.created_at, hostname: @database_reset.hostname, ip: @database_reset.ip, updated_at: @database_reset.updated_at }
    assert_redirected_to database_reset_path(assigns(:database_reset))
  end

  test "should destroy database_reset" do
    assert_difference('DatabaseReset.count', -1) do
      delete :destroy, id: @database_reset
    end

    assert_redirected_to database_resets_path
  end
end
