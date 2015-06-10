class TimesheetPdf < Prawn::Document

  def initialize(timesheet, view)
    super()
    @timesheet = timesheet
    @view = view
    header
    splits
    start_new_page
    header
    intermediates
  end

  def header
    text "#{@timesheet.name}", align: :center, style: :bold
    text "presented by sledsheet.com", align: :center, style: :bold, size: 9
    text "OFFICIAL RESULTS: Skeleton Men", align: :center, size: 8
    text "#{@timesheet.nice_date}", align: :center, size: 8
    if Rails.env.production?
      text "view this timesheet on <u><link href='#{Rails.application.routes.url_helpers.timesheet_url(@timesheet, host: 'www.sledsheet.com')}'>#{Rails.application.routes.url_helpers.timesheet_url(@timesheet, host: 'www.sledsheet.com')}" +
     "</link></u>", inline_format: true, size: 8, align: :center
   else
     text "view this timesheet on <u><link href='#{Rails.application.routes.url_helpers.timesheet_url(@timesheet, host: 'localhost:3000')}'>#{Rails.application.routes.url_helpers.timesheet_url(@timesheet, host: 'localhost:3000')}" +
    "</link></u>", inline_format: true, size: 8, align: :center
    end
  end

  # TABLES

  def splits
    move_down 20
    table row_data, width: bounds.width,
                      cell_style: {size: 8, padding: [3,3,3,3]} do
      row(0).font_style = :bold
      columns(9).align = :right
      columns([2, 9]).font_style = :bold
      self.cells.borders = []
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def intermediates
    move_down 20
    text "Intermediates", align: :center, style: :bold, size: 9
    table intermediate_data, width: bounds.width,
                      cell_style: {size: 8, padding: [3,3,3,3]} do
      self.cells.borders = []
      self.row_colors = ["DDDDDD", "FFFFFF"]
      columns([2, 10]).font_style = :bold
      columns(10).align = :right
      self.header = true
    end
  end

  def differences
    move_down 20
    # THIS WORKS BELOW. NEEDS DIFFERENCE DATA
    # values = cells.columns(3..-1).rows(1..-1)
    # bad = values.filter do |cell|
    #   cell.content.to_i < 10
    # end
    # bad.background_color = "FFAAAA"
    # good = values.filter do |cell|
    #   cell.content.to_i > 11
    # end
    # good.background_color = "AAFFAA"
  end

  # TABLE DATA

  def row_data
    rows = [["Bib", "Nation", "Name", "Start", {content: "Splits", colspan: 4}, "Finish", "Total" ]]
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

  def intermediate_data
    rows = [["Name", "Start", "Intermediates", "Finish", "","","","","","",""]]
    @timesheet.entries.each do |entry|
      if entry.runs.present?
        entry.runs.each do |run|
          if run.position == 1
            rows << [entry.bib, entry.athlete.timesheet_country, entry.athlete.timesheet_name, split(run.start), split(run.int1), split(run.int2),split(run.int3),split(run.int4),split(run.int5),split(run.finish), total(entry.total_time)]
          else
            rows << ["", "", "", split(run.start), split(run.int1), split(run.int2),split(run.int3),split(run.int4),split(run.int5),split(run.finish), ""]
          end
        end
      else
        rows << [entry.bib, entry.athlete.timesheet_country, entry.athlete.timesheet_name, "", "", "", "", "", "", "", ""]
      end
    end
    rows
  end

  def difference_data
  end

  # VIEW HELPERS

  def split(s)
    @view.display_time(s)
  end

  def total(t)
    @view.display_total(t)
  end

end
