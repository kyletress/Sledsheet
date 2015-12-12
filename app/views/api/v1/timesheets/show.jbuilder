json.id @timesheet.id
json.name @timesheet.name
json.date @timesheet.date
json.status @timesheet.status
json.entries @timesheet.entries do |entry|
  json.id entry.id
  json.athlete entry.athlete.name
  json.total_time entry.total_time
end
