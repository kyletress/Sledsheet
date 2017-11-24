$(document).on "turbolinks:load", ->
  $('#flatpickr-input').flatpickr({
      enableTime: true
  })
  $('#filter-submit').hide()
  $('.clear-filters').click ->
    resetForm($('#filters'))
    # clear url and reload, or reload timesheets

  $('#constant').multiselect()

  $('#series').multiselect
    nonSelectedText: 'Select runs'
    enableCaseInsensitiveFiltering: true
    onChange: (option, checked) ->
    # Get selected options.
      selectedOptions = $('#series option:selected')
      if selectedOptions.length >= 4
        # Disable all other checkboxes.
        nonSelectedOptions = $('#series option').filter(->
          !$(this).is(':selected')
        )
        nonSelectedOptions.each ->
          input = $('input:checkbox[value="' + $(this).val() + '"]')
          input.prop 'disabled', true
          input.parent('li').addClass 'disabled'
          return
      else
        # Enable all checkboxes.
        $('#series option').each ->
          input = $('input[value="' + $(this).val() + '"]')
          input.prop 'disabled', false
          input.parent('li').addClass 'disabled'



resetForm = (form) ->
  form.find('select').val('')
