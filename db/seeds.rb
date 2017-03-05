if User.count == 0 && ENV['REVIEW_ENVIRONMENT'] == "true"
  User.create([
    {
      name: "Kyle Tress",
      email: "kyle@kyletress.com",
      password: "password",
      password_confirmation: "password",
      admin: true,
      activated: true
    },
    {
      name: "Morgan Tracey",
      email: "morgangtracey5@gmail.com",
      password: "password",
      password_confirmation: "password",
      admin: false,
      activated: true
    }
  ])
end

if Track.count == 0
  tracks = Track.create([
    { name: 'Altenberg', latitude: 50.782300, longitude: 13.723007 },
    { name: 'Calgary', latitude: 51.076713, longitude: -114.221485 },
    { name: 'Cesana', latitude: 44.952524, longitude: 6.816209 },
    { name: 'Cortina', latitude: 46.545701, longitude: 12.127775 },
    { name: 'Igls', latitude: 47.221125, longitude: 11.435487 },
    { name: 'Konigssee', latitude: 47.590213, longitude: 12.976009 },
    { name: 'La Plagne', latitude: 45.519972, longitude: 6.680548 },
    { name: 'Lake Placid', latitude: 44.213196, longitude: -73.924767},
    { name: 'Lillehammer', latitude: 61.220615, longitude: 10.419124 },
    { name: 'Nagano', latitude: 36.710858, longitude: 138.157331 },
    { name: 'Oberhof', latitude: 50.708923, longitude: 10.707584 },
    { name: 'Paramanovo', latitude: 56.244244, longitude: 37.446495},
    { name: 'Park City', latitude: 40.705174, longitude: -111.563905 },
    { name: 'Sigulda', latitude: 57.151264, longitude: 24.840675 },
    { name: 'Sochi', latitude: 43.662831, longitude: 40.288486 },
    { name: 'St. Moritz', latitude: 46.501569, longitude: 9.847278},
    { name: 'Whistler', latitude: 50.106908, longitude: -122.944761 },
    { name: 'Winterberg', latitude: 51.182209, longitude: 8.508864}
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
  timesheet = Timesheet.create(track: track, circuit: circuit, date: DateTime.now, gender: 0, race: true, complete: true, status: 1, user: User.first, type: 'PublicTimesheet')
end

kyle = Athlete.find_by(last_name: "Tress")
matt = Athlete.find_by(last_name: "Antoine")
john = Athlete.find_by(last_name: "Daly")

timesheet = Timesheet.first

Entry.create([
  {
    athlete: kyle,
    timesheet: timesheet,
    bib: 1,
    status: 0
  },
  {
    athlete: matt,
    timesheet: timesheet,
    bib: 2,
    status: 0
  },
  {
    athlete: john,
    timesheet: timesheet,
    bib: 3,
    status: 0
  }
])

entry = Entry.find_by(athlete_id: kyle.id)

Run.create(
    entry: entry,
    start: 500,
    split2: 2193,
    split3: 3619,
    split4: 4156,
    split5: 4456,
    finish: 5411,
    position: 1,
    status: 0
)
