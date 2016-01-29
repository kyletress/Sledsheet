# json.id @athlete.id
# json.name @athlete.name
# json.country @athlete.timesheet_country
# json.gender @athlete.gender
# json.total @athlete.season_point_total(@season)
json.array! @points do |point|
  json.timesheet_id point.timesheet.id
  json.timesheet_name point.timesheet.short_name
  json.value point.value
  json.rank point.rank
end
