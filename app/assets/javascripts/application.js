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
//= require jquery-ui/sortable
//= require bootstrap
//= require turbolinks
//= require twitter/typeahead
//= require_tree .

// initialize bloodhound engine
// var bloodhound = new Bloodhound({
//   datumTokenizer: function (d) {
//     return Bloodhound.tokenizers.whitespace(d.value);
//   },
//   queryTokenizer: Bloodhound.tokenizers.whitespace,
//
//   // sends ajax request to /typeahead/%QUERY
//   // where %QUERY is user input
//   remote: {
//     url: '/api/athletes?q=%QUERY',
//     wildcard: '%QUERY'
//   },
//   limit: 50
// });
// bloodhound.initialize();

var athletes = new Bloodhound({
  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
  queryTokenizer: Bloodhound.tokenizers.whitespace,
  prefetch: '/api/athletes',
  remote: {
    url: '/api/athletes?q=%QUERY',
    wildcard: '%QUERY'
  }
});

athletes.initialize();

$(document).on('page:change', function() {
  $('#typeahead').typeahead(null, {
    name: 'athletes',
    display: 'name',
    val: 'id',
    source: athletes
  });
});

// $(document).on('page:change', function() {
//   $('#typeahead').typeahead(null, {
//     displayKey: 'name',
//     hint: true,
//     highlight: true,
//     source: bloodhound.ttAdapter()
//   });

// this is the event that is fired when a user clicks on a suggestion
  $('#typeahead').bind('typeahead:selected', function(event, datum, name) {
    doSomething(datum.id);
  });
