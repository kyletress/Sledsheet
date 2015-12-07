json.array! @rankings do |ranking|
  json.id ranking.athlete.id
  json.athlete ranking.athlete.name
  json.world_rank ranking.world_rank.to_s
  json.nation_rank "#{ranking.athlete.timesheet_country} #{ranking.nation_rank.to_s}" 
  json.points ranking.total_points.to_s
  json.country ranking.athlete.timesheet_country
end
