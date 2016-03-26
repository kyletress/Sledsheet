class StartlistPdf < Prawn::Document

  def initialize(timesheet, entries, view)
    super()
    @timesheet = timesheet
    @entries = entries
    @view = view
    header
    startlist
  end

  def header
    text "Startlist - #{@timesheet.name}", align: :center, style: :bold
    text "presented by sledsheet.com", align: :center, style: :bold, size: 7
    text "#{@timesheet.nice_date}", align: :center, size: 7
    if Rails.env.production?
      text "view this timesheet on <u><link href='#{Rails.application.routes.url_helpers.timesheet_url(@timesheet, host: 'www.sledsheet.com')}'>#{Rails.application.routes.url_helpers.timesheet_url(@timesheet, host: 'www.sledsheet.com')}" +
     "</link></u>", inline_format: true, size: 7, align: :center
   else
     text "<u><link href='#{Rails.application.routes.url_helpers.timesheet_url(@timesheet, host: 'localhost:3000')}'>#{Rails.application.routes.url_helpers.timesheet_url(@timesheet, host: 'localhost:3000')}" +
    "</link></u>", inline_format: true, size: 7, align: :center
    end
  end

  # TABLES

  def startlist
    move_down 20
    table split_data, cell_style: {size: 8, padding: [3,3,3,3]} do
      row(0).font_style = :bold
      self.cells.borders = []
    end
    # , width: bounds.width,
    #                   cell_style: {size: 8, padding: [3,3,3,3]} do
    #   row(0).font_style = :bold
    #   columns(9).align = :left
    #   columns([2, 9]).font_style = :bold
    #   self.cells.borders = []
    #   self.row_colors = ["DDDDDD", "FFFFFF"]
    #   self.header = true
    # end
  end

  # TABLE DATA

  def split_data
    rows = [["Pos.", "Country", "Athlete"]]
    @entries.each do |entry|
      rows << [entry.bib, entry.athlete.timesheet_country, entry.athlete.name]
    end
    rows
  end

end
