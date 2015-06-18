namespace :athletes do
  desc 'add full names to athletes'
  task name: :environment do
    Athlete.all.each do |athlete|
      athlete.name = "#{athlete.first_name} #{athlete.last_name}"
      athlete.save
    end
  end
end
