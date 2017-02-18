namespace :athletes do
  desc 'change athlete male boolean to gender enum'
  task set_gender: :environment do
    Athlete.all.each do |a|
      if a.male
        a.gender = 0
      else
        a.gender = 1
      end
      a.save
    end
  end
end
