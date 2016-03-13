if User.count == 0 && ENV['REVIEW_ENVIRONMENT'] == "true"
  user = User.create!(first_name: "Kyle", last_name: "Tress", email: "kyle@kyletress.com", password: "password", password_confirmation: "password", admin: true, activated: true)
  user.toggle!(:admin)
  user.toggle!(:activated)
end

if Track.count == 0
  tracks = Track.create([
    { name: 'Altenberg' },
    { name: 'Calgary' },
    { name: 'Cesana' },
    { name: 'Cortina' },
    { name: 'Igls' },
    { name: 'Konigssee' },
    { name: 'La Plagne' },
    { name: 'Lake Placid' },
    { name: 'Lillehammer' },
    { name: 'Nagano' },
    { name: 'Oberhof' },
    { name: 'Paramanovo' },
    { name: 'Park City' },
    { name: 'Sigulda' },
    { name: 'Sochi' },
    { name: 'St. Moritz' },
    { name: 'Whistler' },
    { name: 'Winterberg' }
  ])
end

if Circuit.count == 0
  circuits = Circuit.create([
    { name: 'World Cup', nickname: 'WC' },
    { name: 'Intercontinental Cup', nickname: 'IC' },
    { name: 'Europa Cup', nickname: 'EC' },
    { name: 'North American Cup', nickname: 'NAC' },
    { name: 'Team Selection', nickname: 'SEL' },
    { name: 'European Championship', nickname: 'ECh' },
    { name: 'North American Championship', nickname: 'NACh' },
    { name: 'World Championship', nickname: 'WCh' },
    { name: 'Regional Championship', nickname: 'RCh' },
    { name: 'International Training Week', nickname: 'ITC' },
    { name: 'Olympic Winter Games', nickname: 'OWG' },
    { name: 'Homologation', nickname: 'HOM' },
    { name: 'Team Event', nickname: 'TE' },
    { name: 'Junior World Championship', nickname: 'JWC' },
    { name: 'Junior National Championship', nickname: 'JNC' },
    { name: 'Club', nickname: 'Cl' },
    { name: 'Unofficial', nickname: 'UT' },
    { name: 'Development', nickname: 'DEV' }
  ])
end

if Athlete.count == 0
  athletes = Athlete.create([
    { first_name: 'Kyle', last_name: 'Tress', country_code: 'US', gender: 0},
    { first_name: 'Matt', last_name: 'Antoine', country_code: 'US', gender: 0},
    { first_name: 'John', last_name: 'Daly', country_code: 'US', gender: 0}
  ])
end

if Timesheet.count == 0
  track = Track.find_by(name: 'Lake Placid')
  circuit = Circuit.find_by(name: 'World Cup')
  timesheet = Timesheet.create(track: track, circuit: circuit, date: DateTime.now, gender: 0, race: true, complete: true, status: 1)
end
