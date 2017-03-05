namespace :timesheets do
  desc 'convert timesheets to STI with type value'
  task convert_to_sti: :environment do
    Timesheet.personal.each do |t|
      t.type = "PrivateTimesheet"
      t.save
    end
    Timesheet.general.each do |t|
      t.type = "PublicTimesheet"
      t.save
    end
  end
end
