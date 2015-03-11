module EntriesHelper
  def display_total(i)
    min = (i / 6000).to_i
    sec = sprintf("%.2f", (i / 100.00) - (min * 60))
    "#{min}:#{sec}"
  end
end
