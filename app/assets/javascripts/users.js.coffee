$(document).on "turbolinks:load", ->
  $('body').on 'shown.bs.modal', '.share-timesheet-modal', (e) ->
    timesheet_id = $(e.relatedTarget).data('timesheet-id')
    $('#timesheet_id').val timesheet_id
