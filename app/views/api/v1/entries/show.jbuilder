json.entry do
  json.id @entry.id
  json.name @entry.athlete.name
  json.total_time @entry.total_time
end
