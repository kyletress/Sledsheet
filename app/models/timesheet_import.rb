require 'nokogiri'
require 'open-uri'

class TimesheetImport

  attr_reader :page

  def initialize(url)
    @page = open_page(url)
  end

  def open_page(url)
    Nokogiri::HTML(open(url))
  end

  def scrape_track
    track = @page.css('.place').text.strip.parameterize(separator: ' ').titleize
    Track.find_by(name: track)
  end

  def scrape_date
    date = @page.css('.date').text.strip
    DateTime.parse date # needs to respect timezone of track.
  end

  def scrape_circuit
    scraped = @page.css('#single_event header h1').text.strip
    case scraped
    when "Europe Cup"
      scraped = "Europa Cup"
    when "BMW IBSF World Cup"
      scraped = "World Cup"
    else
      scraped = scraped
    end

    circuit = Circuit.find_by(name: scraped)
    if circuit == nil
    # assume training if not found
      circuit = Circuit.find_by(name: 'Unofficial')
    end
    circuit
  end

  def scrape_gender
    gender = @page.css('.category').text.strip
    case gender
    when 'Men´s Skeleton'
      0
    when 'Women´s Skeleton'
      1
    when 'Skeleton Women/Men'
      2
    else
      2
    end
  end

  def scrape_kind
    str = @page.css('#single_event header h1').text.strip
    str.include?("Training") ? false : true
  end

  def build_timesheet
    timesheet = Timesheet.create(track: scrape_track, circuit: scrape_circuit, gender: scrape_gender, date: scrape_date, race: scrape_kind, complete: false, status: 0, visibility: 1)
    # entries and runs
    trs = @page.css('.crew, .run').to_a
    entries = trs.slice_before{ |elm| elm.attr('class') =='crew' }.to_a

    entries.map! do |entry|
      {
        name: entry.at(0).css("td.visible-xs div.fl.athletes a").text.strip,
        country: entry.at(0).css("div.fl.athletes img.country-flag").attr('alt').text,
        runs: entry.select{ |tr| tr.attr('class') == 'run' }.map do |run|
          # here I need to ignore '-' runs.
          unless run.css('td')[1].text.strip == '-' && run.css('td')[2].text.strip == '-'
            {
              start: run.css('td')[1].text.strip,
              split2: run.css('td')[2].text.strip,
              split3: run.css('td')[3].text.strip,
              split4: run.css('td')[4].text.strip,
              split5: run.css('td')[5].text.strip,
              finish: run.css('td')[6].text[/([0-1]:[0-5][0-9].[0-9][0-9])|[0-5][0-9].[0-9][0-9]/]
            }
          end
        end
      }
    end

    entries.each do |entry|
      @entry = timesheet.entries.build(
        athlete: Athlete.find_or_create_by_timesheet_name(entry[:name], entry[:country], Timesheet.genders[timesheet.gender])
      )
      @entry.save
      if @entry.errors.any?
        @entry.errors.full_messages.each do |e|
          puts e
        end
      end
      entry[:runs].each do |run|
        unless run.nil?
          @run = @entry.runs.build(
            :start => time_to_integer(run[:start]),
            :split2 => time_to_integer(run[:split2]),
            :split3 => time_to_integer(run[:split3]),
            :split4 => time_to_integer(run[:split4]),
            :split5 => time_to_integer(run[:split5]),
            :finish => time_to_integer(run[:finish])
          )
          @run.save
          if @run.errors.any?
            @run.errors.full_messages.each do |e|
              puts e
            end
          end
        end
      end
    end
  end

  private

    def time_to_integer(time_str)
      if /[:]/ =~ time_str
        minutes, seconds, centiseconds = time_str.split(/[:.]/).map{|str| str.to_i}
        (minutes * 60 + seconds) * 100 + centiseconds
      else
        time_str.delete('.').to_i
      end
    rescue
      99999 # make it high to prevent ranking errors
    end

end
