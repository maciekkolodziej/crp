include ActionView::Helpers::UrlHelper
class DashboardController < ApplicationController   
  def index
    if SaleItem::unrecognized_products?(current_user.current_store_id) && can?(:create, ProductAlias)
      message = [t('unrecognized_products_alert', default: 'There are some unrecognized products among sale items.'), 
                 link_to(t('Click here', default: 'Click here'), unrecognized_products_path), 
                 t('add_alias', default: 'to add alias to missing products.') ]
                 .join(' ').html_safe
      flash.now[:warning] = message
    end
  end
end