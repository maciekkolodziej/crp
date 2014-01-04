require 'test_helper'

class TakingsControllerTest < ActionController::TestCase
  setup do
    @taking = takings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:takings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create taking" do
    assert_difference('Taking.count') do
      post :create, taking: { card_payments: @taking.card_payments, cash_payments: @taking.cash_payments, date: @taking.date, store_id: @taking.store_id, value: @taking.value }
    end

    assert_redirected_to taking_path(assigns(:taking))
  end

  test "should show taking" do
    get :show, id: @taking
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @taking
    assert_response :success
  end

  test "should update taking" do
    patch :update, id: @taking, taking: { card_payments: @taking.card_payments, cash_payments: @taking.cash_payments, date: @taking.date, store_id: @taking.store_id, value: @taking.value }
    assert_redirected_to taking_path(assigns(:taking))
  end

  test "should destroy taking" do
    assert_difference('Taking.count', -1) do
      delete :destroy, id: @taking
    end

    assert_redirected_to takings_path
  end
end
