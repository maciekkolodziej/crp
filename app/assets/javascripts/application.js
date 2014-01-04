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
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery-fileupload
//= require_tree .
//= require wice_grid
//= require jquery.ui.all
//= require select2
//= require select2_locale_pl
//= require cocoon
//= require turbolinks
//= require twitter/bootstrap
//= require twitter-bootstrap-hover-dropdown.min.js 

$(document).ready(function() {
	$('input.ui-date-picker').datepicker();
	$('.dropdown-toggle').dropdownHover();
	$('form .input .controls select').not('.custom-dropdown').select2({'width': 'resolve'});
	$('#modal-window').on('shown', function() { $('form .input .controls select').select2({'width': 'resolve'}); });
	
	// Activate tooltips
	$('a').tooltip({placement: 'bottom'});
	$('a').click(function(){
		$(this).tooltip('hide');
	});
	
	// Move tab toolbars
	$('.tab-toolbar').each(function(){
		parentId = $(this).parent().attr('id');
		$(this).attr('id', parentId + '-toolbar').appendTo('#tab-toolbars');
	});
	$('.tab-toolbar').hide();
	activeTabId = $('.tab-content .tab-pane.active').attr('id');
	
	cookie_name = window.location.pathname + '-active-tab';
	var activeTab = (localStorage.getItem(cookie_name) === null) ? "#tab-1" : localStorage.getItem(cookie_name);
	$(activeTab).addClass('in active');
	$('a[href="'+ activeTab +'"]').parent().addClass('active');
	$(activeTab + '-toolbar').show();
	
	$('a[data-toggle="tab"]').on('shown', function (e) {
	  e.target; // activated tab
	  e.relatedTarget; // previous tab
	  currentTabId = $(e.target).attr('href');
	  localStorage.setItem(cookie_name, currentTabId);
	  $('.tab-toolbar').hide();
	  $(currentTabId + '-toolbar').show();
	});

	$('.action-grid').each(function() {
		grid_name = $(this).find('.wice-grid-container').attr('id');
		
		/* Change status text (e.g. 1-10 / 100) to link, which toggles records per page form.
		 * Move records per page form into it's place and hide it.
		 */ 
		var status = $(this).find('.pagination_status');
		status_text = status.text();
		status.empty().append('<a href="/pl/session/per_page" class="per-page-link" data-remote="true" data-target="#modal-window" data-toggle="modal" style="float: right">' + status_text + '</a>');
		
		// Add hyphen to range filters
		$(this).find('.form-control.input-sm.range-end').before('-');
		
		// Replace filter toggle button with 'search' button and create button group
		actions_th = $(this).find('.wice-grid-title-row').find('th').last();
		$(this).find('.title-row').attr('id', grid_name  + '-title-row');
		actions_th.empty().append('<div class="btn-group pull-right grid-actions"><a class="btn btn-mini filter-toggle" data-toggle="button" href="#'+ grid_name +'-title-row" onclick="toggleFilter('+ "'" + grid_name + "'" + ');"><i class="icon-search"></i></a></div>');
		filter_row = $(this).find('.wg-filter-row');
		if (filter_row.find('th').is(':visible')) {
			$(this).find('.filter-toggle').addClass('active');
		}
		
		// Replace ugly icons with bootstrap buttons
		$(this).find('th.filter_icons').remove();
		filter_submit_th = $(this).find('th.sel');
		buttons = '<div class="btn-toolbar no-margins pull-right"><a href="#" class="btn btn-primary wg-external-submit-button" data-grid-name="'+ grid_name +'">Submit</a>';
		buttons += '<a href="#" class="btn btn-danger wg-external-reset-button" data-grid-name="' + grid_name + '">Reset</a></div>';
		filter_submit_th.attr('colspan', 2).append(buttons);
		
		// If there are recors found...
		if ($('tbody tr').length > 0) {
			// Create averages row if there are some columns to average (with class 'averaged')
			averaged_columns = $(this).find('.averaged');
			if (averaged_columns.length) {  create_averages_row(grid_name);	}
			
			// Create averages row if there are some columns to average (with class 'totalled')
			totalled_columns = $(this).find('.totalled');
			if (totalled_columns.length) {	create_totals_row(grid_name);  }
		}
		// Else (no records)
		else {
			number_of_columns = $(this).find('.wice-grid-title-row th').length;
			$(this).find('.wice-grid tbody').append('<tr class="grey"><td colspan=' + number_of_columns + '>' + t('No records found') + '</td></tr>');
		}
		
		// Removes border between summary rows
		foot_row_count = $(this).find('.wice-grid tfoot tr');
		if (foot_row_count.length > 2) {
			$(this).find('.wice-grid tfoot tr:nth-child(2)').addClass('no-top-border');
		}
		
		// Move batch action buttons into table foot
		batch_actions = $(this).find('.batch-actions');
		if (batch_actions.length) {
			$(this).find('.grid-actions').append(batch_actions.html());
			batch_actions.remove();
		}
		
		// Make batch_action_links submiting form
		$(this).find('.batch-action-link').click(function(){
			form = $(this).closest('form');
			count = form.find('input:checked').length;
			if (count > 0) {
				if (confirm(t("Are you sure you want to update/delete ALL selected items?"))) {
					action_path = $(this).attr('data-controller') + '/' + $(this).attr('data-action');
					full_path = 'http://' + window.location.host + '/' + action_path;
					form.attr('action', full_path);
					form.submit();
				}
			}
			else {
				alert(t('You need to select at least one item...'));
			}
		});
	});

});

function toggleFilter(grid_name) {
	$('#' + grid_name).find('.wg-filter-row').toggle();
}

function close_modal() {
	$('#modal-window').modal('hide'); 
}

function redirect(url) {
	window.location.replace(url);
}

function create_totals_row(grid_name) {
	/* If there are columns to total, go through th's - print "Totals:" 
	*  and for each next draw either empty cell or total value
	*/
	grid = $('#' + grid_name);
	grid.find('table tfoot').prepend('<tr class="totals"></tr>');
	var column_number = 1;
	grid.find('tr.wice-grid-title-row th').each(function(){
		if (column_number == 1) {
			grid.find('tr.totals').append('<td>' + t('Totals') + ': </td>');
			column_number++;
		}
		
		else if ($(this).hasClass('totalled')) {
			var classes = $(this).attr('class');
			joined_classes = classes.split(' ').join('.');

			var total = 0;
			grid.find('tbody td.' + joined_classes).each(function() {
				string = $(this).text();
				number = (string) ? parseFloat(string) : 0;
				total += number;
			});
			grid.find('tr.totals').append('<td class="' + classes + '">'+ total.toFixed(2) + '</td>');
			column_number++;
		}
		
		else {
			grid.find('tr.totals').append('<td></td>');
		}
	});
};

function create_averages_row(grid_name) {
	/* If there are columns to average, go through th's - print "Averages:" 
	 * and for each next draw either empty cell or total value
	 */
	grid = $('#' + grid_name);
	grid.find('table.wice-grid tfoot').prepend('<tr class="averages"></tr>');
	var column_number = 1;
	grid.find('tr.wice-grid-title-row th').each(function(){
		if (column_number == 1) {
			grid.find('tr.averages').append('<td>' + t('Averages') + ': </td>');
			column_number++;
		}
		
		else if ($(this).hasClass('averaged')) {
			var classes = $(this).attr('class');
			joined_classes = classes.split(' ').join('.');

			var total = 0;
			var count = 0;
			grid.find('tbody td.' + joined_classes).each(function() {
				string = $(this).text();
				number = parseFloat(string);
				total += (string) ? parseFloat(string) : 0;
				if(string) {
					count++;
				}
				average = total / count;
			});
			grid.find('tr.averages').append('<td class="' + classes + '">'+ average.toFixed(2) + '</td>');
			column_number++;
		}
		
		else {
			grid.find('tr.averages').append('<td></td>');
		}
	});
};

function t(message) {
	switch(locale) {
		case 'pl':
			switch(message) {
				case 'No records found': 							message = 'Nie znaleziono rekordów'; break;
				case 'Averages':  									message = 'Średnie'; break;
				case 'Totals': 										message = 'Sumy'; break;
				case 'You need to select at least one item...': 	message = 'Należy wybrać przynajmniej jedną pozycję...'; break;
				case 'Are you sure you want to update/delete ALL selected items?': 	message = 'Napewno zaktualizować/usunąć WSZYSTKIE wybrane pozycje?'; break;
			}
			break;
	}
	return message;
}
