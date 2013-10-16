require 'test_helper'

class SaleItemsControllerTest < ActionController::TestCase
  setup do
    @sale_item = sale_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sale_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sale_item" do
    assert_difference('SaleItem.count') do
      post :create, sale_item: { line_number: @sale_item.line_number, net_value: @sale_item.net_value, product_id: @sale_item.product_id, product_name: @sale_item.product_name, quantity: @sale_item.quantity, receipt_id: @sale_item.receipt_id, value: @sale_item.value, vat_rate: @sale_item.vat_rate, vat_symbol: @sale_item.vat_symbol }
    end

    assert_redirected_to sale_item_path(assigns(:sale_item))
  end

  test "should show sale_item" do
    get :show, id: @sale_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sale_item
    assert_response :success
  end

  test "should update sale_item" do
    patch :update, id: @sale_item, sale_item: { line_number: @sale_item.line_number, net_value: @sale_item.net_value, product_id: @sale_item.product_id, product_name: @sale_item.product_name, quantity: @sale_item.quantity, receipt_id: @sale_item.receipt_id, value: @sale_item.value, vat_rate: @sale_item.vat_rate, vat_symbol: @sale_item.vat_symbol }
    assert_redirected_to sale_item_path(assigns(:sale_item))
  end

  test "should destroy sale_item" do
    assert_difference('SaleItem.count', -1) do
      delete :destroy, id: @sale_item
    end

    assert_redirected_to sale_items_path
  end
end
