require 'test_helper'

class SalesReceiptsControllerTest < ActionController::TestCase
  setup do
    @sales_receipt = sales_receipts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales_receipts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sales_receipt" do
    assert_difference('SalesReceipt.count') do
      post :create, sales_receipt: {  }
    end

    assert_redirected_to sales_receipt_path(assigns(:sales_receipt))
  end

  test "should show sales_receipt" do
    get :show, id: @sales_receipt
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sales_receipt
    assert_response :success
  end

  test "should update sales_receipt" do
    patch :update, id: @sales_receipt, sales_receipt: {  }
    assert_redirected_to sales_receipt_path(assigns(:sales_receipt))
  end

  test "should destroy sales_receipt" do
    assert_difference('SalesReceipt.count', -1) do
      delete :destroy, id: @sales_receipt
    end

    assert_redirected_to sales_receipts_path
  end
end
