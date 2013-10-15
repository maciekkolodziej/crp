require 'test_helper'

class SalesControllerTest < ActionController::TestCase
  setup do
    @sale = sales(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sale" do
    assert_difference('Sale.count') do
      post :create, sale: { cash: @sale.cash, company_id: @sale.company_id, created_by: @sale.created_by, date: @sale.date, net_value: @sale.net_value, number: @sale.number, pos_id: @sale.pos_id, receipt_count: @sale.receipt_count, updated_by: @sale.updated_by, value: @sale.value, vat: @sale.vat }
    end

    assert_redirected_to sale_path(assigns(:sale))
  end

  test "should show sale" do
    get :show, id: @sale
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sale
    assert_response :success
  end

  test "should update sale" do
    patch :update, id: @sale, sale: { cash: @sale.cash, company_id: @sale.company_id, created_by: @sale.created_by, date: @sale.date, net_value: @sale.net_value, number: @sale.number, pos_id: @sale.pos_id, receipt_count: @sale.receipt_count, updated_by: @sale.updated_by, value: @sale.value, vat: @sale.vat }
    assert_redirected_to sale_path(assigns(:sale))
  end

  test "should destroy sale" do
    assert_difference('Sale.count', -1) do
      delete :destroy, id: @sale
    end

    assert_redirected_to sales_path
  end
end
