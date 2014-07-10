# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('#entries').sortable
    axis: 'y'
    opacity: 0.7
    placeholder: 'sortable-placeholder'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))