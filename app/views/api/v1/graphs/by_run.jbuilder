runs = Run.find(@series)
runs << @constant

json.array! runs do |run|
json.name run.entry.athlete.name
differences = run.difference_from(@constant)
json.data do
  json.s1 differences[0]
  json.s2 differences[1]
  json.s3 differences[2]
  json.s4 differences[3]
  json.s5 differences[4]
  json.s6 differences[5]
end
end
