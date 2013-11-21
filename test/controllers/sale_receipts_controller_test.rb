require 'test_helper'

class SaleReceiptsControllerTest < ActionController::TestCase
  setup do
    @sale_receipt = sale_receipts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sale_receipts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sale_receipt" do
    assert_difference('SaleReceipt.count') do
      post :create, sale_receipt: { cancelled: @sale_receipt.cancelled, datetime: @sale_receipt.datetime, id: @sale_receipt.id, net_value: @sale_receipt.net_value, number: @sale_receipt.number, sale_id: @sale_receipt.sale_id, salesman_id: @sale_receipt.salesman_id, value: @sale_receipt.value }
    end

    assert_redirected_to sale_receipt_path(assigns(:sale_receipt))
  end

  test "should show sale_receipt" do
    get :show, id: @sale_receipt
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sale_receipt
    assert_response :success
  end

  test "should update sale_receipt" do
    patch :update, id: @sale_receipt, sale_receipt: { cancelled: @sale_receipt.cancelled, datetime: @sale_receipt.datetime, id: @sale_receipt.id, net_value: @sale_receipt.net_value, number: @sale_receipt.number, sale_id: @sale_receipt.sale_id, salesman_id: @sale_receipt.salesman_id, value: @sale_receipt.value }
    assert_redirected_to sale_receipt_path(assigns(:sale_receipt))
  end

  test "should destroy sale_receipt" do
    assert_difference('SaleReceipt.count', -1) do
      delete :destroy, id: @sale_receipt
    end

    assert_redirected_to sale_receipts_path
  end
end
