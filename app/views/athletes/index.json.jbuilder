json.athletes @athletes do |athlete|
  json.id athlete.id
  json.first_name athlete.first_name
  json.last_name athlete.last_name
  json.name athlete.name
  json.image athlete.avatar_url
end
