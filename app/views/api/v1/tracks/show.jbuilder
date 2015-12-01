json.track do
  json.id @track.id
  json.name @track.name
  json.records do
    json.skeleton do
      json.men do
        json.start do
          json.time @track.start_record_men
          json.athlete "Martins Dukurs"
          json.date "2015-11-17"
        end
        json.finish do
          json.time @track.track_record_men
        end
      end
      json.women do
        json.start do
          json.time @track.start_record_women
        end
        json.finish do
          json.time @track.track_record_women
        end
      end
    end
  end
end
