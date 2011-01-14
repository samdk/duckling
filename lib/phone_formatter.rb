class PhoneFormatter
  def self.format(number)
    number = number.gsub(/[^0-9]/,'')
    
    if number.length == 10
      '+1' + number
    else
      number
    end
  end
end