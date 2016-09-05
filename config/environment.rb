# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Time::DATE_FORMATS[:starts_at] = lambda do |date|
  date.strftime "%B #{ActiveSupport::Inflector.ordinalize(date.day)}, %-l:%M%P"
end
