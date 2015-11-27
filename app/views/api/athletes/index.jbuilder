# json.athletes @athletes do |athlete|
#   json.id athlete.id
#   json.name athlete.name
# end

json.array! @athletes do |athlete|
  json.id athlete.id
  json.name athlete.name
end
