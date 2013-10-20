require 'test_helper'

class VatRatesControllerTest < ActionController::TestCase
  setup do
    @vat_rate = vat_rates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vat_rates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vat_rate" do
    assert_difference('VatRate.count') do
      post :create, vat_rate: {  }
    end

    assert_redirected_to vat_rate_path(assigns(:vat_rate))
  end

  test "should show vat_rate" do
    get :show, id: @vat_rate
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vat_rate
    assert_response :success
  end

  test "should update vat_rate" do
    patch :update, id: @vat_rate, vat_rate: {  }
    assert_redirected_to vat_rate_path(assigns(:vat_rate))
  end

  test "should destroy vat_rate" do
    assert_difference('VatRate.count', -1) do
      delete :destroy, id: @vat_rate
    end

    assert_redirected_to vat_rates_path
  end
end
