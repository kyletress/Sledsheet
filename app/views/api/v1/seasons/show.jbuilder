# json.season do
#   json.name @season.name
#
#   json.men do
#     json.rankings @mens_rankings do |ranking|
#       json.world_rank ranking.world_rank
#       json.nation_rank ranking.nation_rank
#       json.nation ranking.athlete.timesheet_country
#       json.athlete ranking.athlete.name
#       json.points ranking.total_points
#     end
#   end
#
#   json.women do
#     json.rankings @womens_rankings do |ranking|
#       json.world_rank ranking.world_rank
#       json.nation_rank ranking.nation_rank
#       json.athlete ranking.athlete.name
#       json.points ranking.total_points
#     end
#   end
# end

json.array! @rankings do |ranking|
  json.id ranking.athlete.id
  json.athlete ranking.athlete.name
  json.world_rank ranking.world_rank
  json.nation_rank ranking.nation_rank
  json.points ranking.total_points
end
