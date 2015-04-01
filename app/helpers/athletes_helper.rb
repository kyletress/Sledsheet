module AthletesHelper
  
  def rank_icon(place)
    if place == 1
      content_tag :svg, version:'1.1', width:'10', height:'10', xmlns:'http://www.w3.org/2000/svg' do 
        tag :circle, cx:'5', cy:'5', r:'5', style:'fill:#c98910'
      end
    elsif place == 2
      content_tag :svg, version:'1.1', width:'10', height:'10', xmlns:'http://www.w3.org/2000/svg' do 
        tag :circle, cx:'5', cy:'5', r:'5', style:'fill:#a8a8a8'
      end
    elsif place == 3
      content_tag :svg, version:'1.1', width:'10', height:'10', xmlns:'http://www.w3.org/2000/svg' do 
        tag :circle, cx:'5', cy:'5', r:'5', style:'fill:#965a38'
      end
    else
    end
  end

end
