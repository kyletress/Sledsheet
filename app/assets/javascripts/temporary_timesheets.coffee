App.spreadsheet =
  setup: () ->
    container = document.getElementById('spreadsheet')
    @hot = new Handsontable(container,
      data: $('div[data-raw-csv]').data('rawCsv')
      minSpareCols: 1
      minSpareRows: 1
      rowHeaders: true
      colHeaders: true
      contextMenu: true
      licenseKey: 'non-commercial-and-evaluation'
    )
    console.log(data)

$ -> App.spreadsheet.setup()
