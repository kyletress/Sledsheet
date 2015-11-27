json.tracks @tracks do |track|
  json.id track.id
  json.name track.name
  json.records do
    json.skeleton do
      json.men do
        json.finish track.track_record_men
       end
      json.women do
        json.finish track.track_record_women
      end
    end
  end
end
