$(document).on "page:change", ->
  $('#filter-submit').hide()
  $('.clear-filters').click ->
    resetForm($('#filters'))
    # clear url and reload, or reload timesheets

resetForm = (form) ->
  form.find('select').val('')
