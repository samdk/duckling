class PhoneFormatter
  def self.format(number)
    number = number.gsub(/[^0-9]/,'')
    
    if number.length == 10
      "#{number[0..2]}-#{number[3..5]}-#{number[6..9]}"
    elsif number.length == 7
      "#{number[0..3]}-#{number[3..6]}"
    else
      "#{number[0]}-#{number[1..3]}-#{number[4..6]}-#{number[7..10]}"
    end
  end
end
