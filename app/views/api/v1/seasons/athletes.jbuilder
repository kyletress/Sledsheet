json.id @athlete.id
json.name @athlete.name
json.country @athlete.timesheet_country
json.gender @athlete.gender
json.total @athlete.season_point_total(@season)
json.points @points do |point|
  json.id point.timesheet.id
  json.timesheet point.timesheet.short_name
  json.value point.value
end
