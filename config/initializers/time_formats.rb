formats = {
  time: "%l:%M %p",           # hour:minute am/pm
  mdy:  "%m/%d/%y",           # month/day/year
  date: "%A, %B %-d",          # day name, month name, day
  date_year: "%A, %B %-d (%Y)" # day name, month name, day (year)
}

formats.each do |k,v|
  Time::DATE_FORMATS[k] = v
  Date::DATE_FORMATS[k] = v
end
