require 'Pdftable'

Pdftable.configure do |p|
  p.key = ENV['PDFTABLE_API_KEY']
end
