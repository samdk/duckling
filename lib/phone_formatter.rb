class PhoneFormatter
  def self.format(number)
    number = number.gsub(/[^0-9]/,'')
    
    return number if number.length < 7
    
    case number.length
      when 10 then "#{number[0..2]}-#{number[3..5]}-#{number[6..9]}"
      when 7  then "#{number[0..3]}-#{number[3..6]}"
      else         number
    end
  end
end
