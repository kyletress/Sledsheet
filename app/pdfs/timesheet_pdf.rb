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
    start_new_page
    header
    differences
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
    table split_data, width: bounds.width,
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
    text "Differences", align: :center, style: :bold, size: 9
    table difference_data, width: bounds.width,
                              cell_style: {size: 8, padding: [3,3,3,3]} do
      self.cells.borders = []
      self.row_colors = ["DDDDDD", "FFFFFF"]
      columns([2, 10]).font_style = :bold
      columns(10).align = :right
      self.header = true
      # THIS WORKS BELOW. NEEDS DIFFERENCE DATA
      values = cells.columns(3..-1).rows(1..-1)
      minus = values.filter do |cell|
        cell.content.to_i > 0
      end
      minus.background_color = "FFAAAA"
      plus = values.filter do |cell|
        cell.content.to_i < 0
      end
      plus.background_color = "AAFFAA"
    end
  end

  # TABLE DATA

  def split_data
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
    rows = [["Bib", "Nation", "Name", "Start", {content: "Splits", colspan: 4}, "Finish"]]
    best = @timesheet.best_run(1)
    @timesheet.entries.each do |entry|
      if entry.runs.present?
        entry.runs.each do |run|
          rows << [
            entry.bib,
            entry.athlete.timesheet_country,
            entry.athlete.timesheet_name,
            run.difference_from(best)[0],
            run.difference_from(best)[1],
            run.difference_from(best)[2],
            run.difference_from(best)[3],
            run.difference_from(best)[4],
            run.difference_from(best)[5]]
        end
      else
        rows << [
          entry.bib,
          entry.athlete.timesheet_country,
          entry.athlete.timesheet_name,
          "", "", "", "", "", "", ""]
      end
    end
    rows
  end

  # VIEW HELPERS

  def split(s)
    @view.display_time(s)
  end

  def total(t)
    @view.display_total(t)
  end

end
