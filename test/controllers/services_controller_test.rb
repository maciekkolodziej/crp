require 'test_helper'

class ServicesControllerTest < ActionController::TestCase
  setup do
    @service = services(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:services)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create service" do
    assert_difference('Service.count') do
      post :create, service: { active: @service.active, category_id: @service.category_id, name: @service.name, register_code: @service.register_code, register_name: @service.register_name, sellable: @service.sellable, unit_id: @service.unit_id, vat_rate_id: @service.vat_rate_id }
    end

    assert_redirected_to service_path(assigns(:service))
  end

  test "should show service" do
    get :show, id: @service
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @service
    assert_response :success
  end

  test "should update service" do
    patch :update, id: @service, service: { active: @service.active, category_id: @service.category_id, name: @service.name, register_code: @service.register_code, register_name: @service.register_name, sellable: @service.sellable, unit_id: @service.unit_id, vat_rate_id: @service.vat_rate_id }
    assert_redirected_to service_path(assigns(:service))
  end

  test "should destroy service" do
    assert_difference('Service.count', -1) do
      delete :destroy, id: @service
    end

    assert_redirected_to services_path
  end
end
