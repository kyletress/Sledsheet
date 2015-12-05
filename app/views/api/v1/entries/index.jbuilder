json.entries @entries do |entry|
  json.id entry.id
  json.athlete entry.athlete.name
end
