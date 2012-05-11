module UpdatesHelper
  def interstitial_date(time)
    if Time.now.year == time.year
      if Date.today == time.to_date
        'Today'
      elsif time.to_date == Date.yesterday
        'Yesterday'
      else
        time.to_s(:date)
      end
    else
      time.to_s(:date_year)
    end
  end

  def month_jumper
    days = Date.today.at_beginning_of_month.step(Date.today.at_end_of_month).collect {|x|x}
    spread = [[]]
    cur = 0
    (0..days[0].wday-1).each {spread[cur] << nil}
    days.each do |day|
      if spread[cur].length == 7
        cur += 1
        spread << []
      end
      spread[cur] << day
    end
    (0..spread[cur].length-7).each {spread << nil}
    x = spread.collect do |line|
      linked = line.collect do |day|
        if day.nil?
          '  '
        else
          if day.future?
            day.day.to_s.rjust(2)
          else
            (link_to day.day, "##{day.to_s(:mdy).gsub('/','-')}").rjust(26)
          end
        end
      end
      "<div class=\"cal-line\">#{linked.join(' ')}</div>"
    end
    first_line = "#{Date::MONTHNAMES[days[0].month]} #{days[0].year}".center(18)
    first_line = "<a href=\"#\">&#x25C0</a>#{first_line}<a href=\"#\">&#x25B6</a>"
    "<pre class=\"calendar\"><div class=\"cal-title\">#{first_line}</div>#{x.join}</pre>"
  end
end
