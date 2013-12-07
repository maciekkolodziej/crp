var products;
products = function(){
	sellable = $("#product_sellable");
	purchasable = $('#product_purchasable');
	// Initial hide
	if (sellable.attr('checked') != 'checked') {
		$('.sellable').hide();
	}
	if (purchasable.attr('checked') != 'checked') {
		$('.purchasable').hide();
	}
	// Toggle
	sellable.click(function(){
		$('.sellable').toggle();
	});
	purchasable.click(function(){
		$('.purchasable').toggle();
	});
	
	
};

$(document).ready(products);
$(document).on('page:load', products);
