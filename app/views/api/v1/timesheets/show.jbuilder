json.id @timesheet.id
json.name @timesheet.name
json.date @timesheet.date
json.status @timesheet.status
if params.has_key?(:entries)
  json.entries @entries do |entry|
    json.id entry.id
    json.athlete entry.athlete.name
    json.total_time entry.total_time
    if params.has_key?(:runs)
      json.runs entry.runs do |run|
        json.id run.id
        json.start run.start
        json.split2 run.split2
        json.split3 run.split3
        json.split4 run.split4
        json.split5 run.split5
        json.finish run.finish
        json.start_rank @runs.find{|r| r.id == run.id}.start_rank
        json.split2_rank @runs.find{|r| r.id == run.id}.split2_rank
        json.split3_rank @runs.find{|r| r.id == run.id}.split3_rank
        json.split4_rank @runs.find{|r| r.id == run.id}.split4_rank
        json.split5_rank @runs.find{|r| r.id == run.id}.split5_rank
        json.finish_rank @runs.find{|r| r.id == run.id}.finish_rank
      end
    end
  end
end
