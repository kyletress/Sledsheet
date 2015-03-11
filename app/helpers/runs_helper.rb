module RunsHelper
  def display_time(i)
    unless i.nil?
      sprintf("%.2f", i / 100.00)
    end
  end
end
