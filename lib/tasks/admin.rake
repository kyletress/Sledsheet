desc "Find and save circuits, tracks for friendly id slug creation"
task find_each_and_save: :environment do
  Track.find_each(&:save)
  Circuit.find_each(&:save)
  Athlete.find_each(&:save)
  Timesheet.find_each(&:save)
  Season.find_each(&:save)
end
