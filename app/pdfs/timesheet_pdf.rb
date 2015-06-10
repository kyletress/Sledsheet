class TimesheetPdf < Prawn::Document

  def initialize(timesheet, view)
    super()
    @timesheet = timesheet
    @view = view
    header
    entries
  end

  def header
    text "#{@timesheet.name}", align: :center, style: :bold
    text "presented by sledsheet.com", align: :center, style: :bold, size: 9
    text "OFFICIAL RESULTS: Skeleton Men", align: :center, size: 8
    text "#{@timesheet.nice_date}", align: :center, size: 8
    text "view this timesheet on <u><link href='#{Rails.application.routes.url_helpers.timesheet_url(@timesheet, host: 'www.sledsheet.com')}'>#{Rails.application.routes.url_helpers.timesheet_url(@timesheet, host: 'www.sledsheet.com')}" +
   "</link></u>", inline_format: true, size: 8, align: :center
  end

  def entries
    move_down 20
    table row_data, width: bounds.width, cell_style: {size: 8} do
      row(0).font_style = :bold
      #columns(0).width = 10
      columns(9).align = :right
      columns(2).font_style = :bold
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def split(s)
    @view.display_time(s)
  end

  def total(t)
    @view.display_total(t)
  end

  def row_data
    rows = [["Bib", "Nation", "Name", "Start", "Splits", "", "", "", "Finish", "Total" ]]
    @timesheet.entries.each do |entry|
      if entry.runs.present?
        entry.runs.each do |run|
          if run.position == 1
            rows << [entry.bib, entry.athlete.timesheet_country, entry.athlete.timesheet_name, split(run.start), split(run.split2), split(run.split3),split(run.split4),split(run.split5),split(run.finish), total(entry.total_time)]
          else
            rows << ["", "", "", split(run.start), split(run.split2), split(run.split3),split(run.split4),split(run.split5),split(run.finish), ""]
          end
        end
      else
        rows << [entry.bib, entry.athlete.timesheet_country, entry.athlete.timesheet_name, "", "", "", "", "", "", ""]
      end
    end
    rows
  end

end
