class User < ActiveRecord::Base
  is_soft_deleted
  serialize :phone_numbers, Hash
  
  before_save do |user|
    user.phone_numbers.to_a.each do |k, v|
      user.phone_numbers[k] = PhoneFormatter.format(v)
    end
  end
  
  after_initialize do |user|
    user.phone_numbers ||= {}
  end
  
end
