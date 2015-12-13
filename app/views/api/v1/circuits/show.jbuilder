json.id @circuit.id
json.name @circuit.name
if params[:includes] == "points"
  if @rankings.present?
    json.rankings @rankings do |ranking|
      json.rank ranking.rank
      json.athlete ranking.athlete.name
      json.points ranking.total_points
    end
  end
end
