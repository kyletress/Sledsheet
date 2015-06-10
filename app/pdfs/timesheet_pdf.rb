class TimesheetPdf < Prawn::Document

  def initialize(timesheet, view)
    super()
    @timesheet = timesheet
    @view = view
    text "#{@timesheet.name}", align: :center, style: :bold
    text "presented by sledsheet.com", align: :center, style: :bold, size: 9
    text "OFFICIAL RESULTS: Skeleton Men", align: :center, size: 8
    text "#{@timesheet.nice_date}", align: :center, size: 8
    text "view this timesheet on <u><link href='#{Rails.application.routes.url_helpers.timesheet_url(@timesheet, host: 'www.sledsheet.com')}'>#{Rails.application.routes.url_helpers.timesheet_url(@timesheet, host: 'www.sledsheet.com')}" +
   "</link></u>", inline_format: true, size: 8, align: :center
   entries
  end

  def entries
    move_down 20
    table entry_rows, width: bounds.width, cell_style: {size: 8} do
      row(0).font_style = :bold
      #columns(0).width = 10
      columns(9).align = :right
      columns(2).font_style = :bold
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def entry_rows
    [["Bib", "Nation", "Name", "Start", "Splits", "", "", "", "Finish", "Total" ]] +
    @timesheet.entries.map do |entry|
      [entry.bib, entry.athlete.timesheet_country, entry.athlete.timesheet_name] +
      if entry.runs.present?
        [split(entry.runs.first.start), split(entry.runs.first.split2), split(entry.runs.first.split3), split(entry.runs.first.split4), split(entry.runs.first.split5), split(entry.runs.first.finish), split(entry.total_time)]
      else
        ["", "", "", "", "", "", ""]
      end
    end
  end

  def split(s)
    @view.display_time(s)
  end

end
