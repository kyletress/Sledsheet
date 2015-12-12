json.athlete do
  json.id @athlete.id
  json.name @athlete.name
  json.country @athlete.timesheet_country
  json.gender @athlete.gender
  json.total @athlete.season_point_total(@season)
  json.points @points do |point|
    json.timesheet point.timesheet.short_name
    json.value point.value
  end
end
