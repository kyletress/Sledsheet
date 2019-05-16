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
//= require jquery-ui/widgets/sortable
//= require bootstrap
//= require activestorage
//= require turbolinks
//= require twitter/typeahead
//= require bootstrap-multiselect
//= require Chart.bundle
//= require chartkick
//= require moment
//= require flatpickr
//= require_tree .

var athletes = new Bloodhound({
  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
  queryTokenizer: Bloodhound.tokenizers.whitespace,
  prefetch: {
    url: '/api/v1/athletes'
  }
});

athletes.initialize();

$(document).on('turbolinks:load', function() {
  $('#typeahead').typeahead(null, {
    name: 'athletes',
    display: 'name',
    highlight: true,
    source: athletes
  });
  $('#typeahead').bind('typeahead:selected typeahead:autocompleted', function(ev, suggestion) {
    console.log('Selection: ' + suggestion.id);
    $('#entry_athlete_id').val(suggestion.id);
  });
});

$(document).ready(function() {
  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination a[rel="next"]').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $('.pagination').text("Please Wait...");
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
});
