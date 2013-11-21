// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .
//= require wice_grid
//= require jquery.ui.all
//= require cocoon

var ready;
ready = function() {
	// Change Store
	$('#user_current_store_id').change(function(){
		$(this).closest("form").submit();
	});
	
	var wice_grid = $('.wice-grid');
	if (wice_grid.length) {
		
		/* Change status text (e.g. 1-10 / 100) to link, which toggles records per page form.
		 * Move records per page form into it's place and hide it.
		 */ 
		var status_text = $('.pagination_status').text();
		$('.pagination_status').empty().append('<a href="#per_page_input" class="records_per_page_link" style="float: right">' + status_text + '</a>');
		$('#records_per_page_form').prependTo('.pagination_status').hide();
		$('.records_per_page_link').click(function(){ 
			$('#records_per_page_form').toggle();
		});
		
		// Add hyphen to range filters
		$('.form-control.input-sm.range-start').after('-');
		
		// Replace ugly icons with bootstrap buttons
		$('.wice-grid th.filter_icons').remove();
		filter_submit_th = $('.wice-grid th.sel');
		buttons = '<div class="btn-toolbar no-margins pull-right"><a href="#" class="btn btn-primary wg-external-submit-button" data-grid-name="grid">Submit</a>';
		buttons += '<a href="#" class="btn btn-danger wg-external-reset-button" data-grid-name="grid">Reset</a></div>';
		filter_submit_th.attr('colspan', 2).append(buttons);
		
		// If there are recors found...
		if ($('tbody tr').length > 0) {
			// Create averages row if there are some columns to average (with class 'averaged')
			averaged_columns = $('.averaged');
			if (averaged_columns.length) {  create_averages_row();	}
			
			// Create averages row if there are some columns to average (with class 'totalled')
			totalled_columns = $('.totalled');
			if (totalled_columns.length) {	create_totals_row();  }
		}
		// Else (no records)
		else {
			number_of_columns = $('.wice-grid-title-row th').length;
			$('.wice-grid tbody').append('<tr class="grey"><td colspan=' + number_of_columns + '>No records found</td></tr>');
		}
		
		// Removes border between summary rows
		foot_row_count = $('.wice-grid tfoot tr');
		if (foot_row_count.length > 2) {
			$('.wice-grid tfoot tr:nth-child(2)').addClass('no-top-border');
		}
		
		// Replace filter toggle button with 'search' button and create button group
		actions_th = $('.wice-grid thead tr.wice-grid-title-row').find('th').last();
		actions_th.empty().append('<div class="btn-group pull-right" id="grid-actions-group"><a class="btn btn-mini filter-toggle" href="#grid_title"><i class="icon-search"></i></a></div>');
		filter_row = $('#grid_filter_row');
		if (filter_row.find('th').is(':visible')) {
			$('.filter-toggle').addClass('active');
		}
		
		$('.filter-toggle').click(function() {
			$('#grid_filter_row').toggle();
			$(this).toggleClass('active');
		});
		
		// Move batch action buttons into table foot
		batch_actions = $('#batch_actions');
		if (batch_actions.length) {
			$('#grid-actions-group').append(batch_actions.html());
			batch_actions.remove();
		}
		
		// Make batch_action_links submiting form
		$('.batch_action_link').click(function() {
			count_selected = $('#batch_action_form input:checkbox:checked').length;
			if (count_selected > 0) {
				if(confirm(count_selected + " records will be deleted/updated at once. Are you sure?")) {
					form = $('#batch_action_form');
					action_name = window.location.pathname + '/' + $(this).attr('data-action-name');
					form.attr('action', action_name).submit();
				}
			}
			else {
				alert("You need to select at least one item...");
			}
		});
	}
};

$(document).ready(ready);
$(document).on('page:load', ready);

function create_totals_row() {
	/* If there are columns to total, go through th's - print "Totals:" 
	*  and for each next draw either empty cell or total value
	*/
	$('table.wice-grid tfoot').prepend('<tr class="totals"></tr>');
	var column_number = 1;
	$('tr.wice-grid-title-row th').each(function(){
		if (column_number == 1) {
			$('tr.totals').append('<td colspan="2">Totals: </td>');
			column_number++;
		}
		
		else if (column_number == 2) {
			column_number++;
		}
		
		else if ($(this).hasClass('totalled')) {
			var classes = $(this).attr('class');
			joined_classes = classes.split(' ').join('.');

			var total = 0;
			$('td.' + joined_classes).each(function() {
				string = $(this).text();
				number = parseFloat(string);
				total += number;
			});
			$('tr.totals').append('<td class="' + classes + '">'+ total.toFixed(2) + '</td>');
			column_number++;
		}
		
		else {
			$('tr.totals').append('<td></td>');
		}
	});
};

function create_averages_row() {
	/* If there are columns to average, go through th's - print "Averages:" 
	 * and for each next draw either empty cell or total value
	 */
	$('table.wice-grid tfoot').prepend('<tr class="averages"></tr>');
	var column_number = 1;
	$('tr.wice-grid-title-row th').each(function(){
		if (column_number == 1) {
			$('tr.averages').append('<td colspan="2">Averages: </td>');
			column_number++;
		}
		
		else if (column_number == 2) {
			column_number++;
		}
		
		else if ($(this).hasClass('averaged')) {
			var classes = $(this).attr('class');
			joined_classes = classes.split(' ').join('.');

			var total = 0;
			var count = 0;
			$('td.' + joined_classes).each(function() {
				string = $(this).text();
				number = parseFloat(string);
				total += number;
				count++;
				average = total / count;
			});
			$('tr.averages').append('<td class="' + classes + '">'+ average.toFixed(2) + '</td>');
			column_number++;
		}
		
		else {
			$('tr.averages').append('<td></td>');
		}
	});
};