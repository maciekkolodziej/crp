require 'test_helper'

class StockablesControllerTest < ActionController::TestCase
  setup do
    @stockable = stockables(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stockables)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stockable" do
    assert_difference('Stockable.count') do
      post :create, stockable: { active: @stockable.active, cost_price: @stockable.cost_price, max_quantity: @stockable.max_quantity, min_quantity: @stockable.min_quantity, name: @stockable.name, purchasable: @stockable.purchasable, register_code: @stockable.register_code, register_name: @stockable.register_name, sale_price: @stockable.sale_price, sellable: @stockable.sellable, unit_id: @stockable.unit_id, vat_rate_id: @stockable.vat_rate_id }
    end

    assert_redirected_to stockable_path(assigns(:stockable))
  end

  test "should show stockable" do
    get :show, id: @stockable
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stockable
    assert_response :success
  end

  test "should update stockable" do
    patch :update, id: @stockable, stockable: { active: @stockable.active, cost_price: @stockable.cost_price, max_quantity: @stockable.max_quantity, min_quantity: @stockable.min_quantity, name: @stockable.name, purchasable: @stockable.purchasable, register_code: @stockable.register_code, register_name: @stockable.register_name, sale_price: @stockable.sale_price, sellable: @stockable.sellable, unit_id: @stockable.unit_id, vat_rate_id: @stockable.vat_rate_id }
    assert_redirected_to stockable_path(assigns(:stockable))
  end

  test "should destroy stockable" do
    assert_difference('Stockable.count', -1) do
      delete :destroy, id: @stockable
    end

    assert_redirected_to stockables_path
  end
end
