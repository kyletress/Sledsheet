json.entries @entries do |entry|
  json.id entry.id
  json.athlete entry.athlete.name
  json.total_time entry.total_time
end
