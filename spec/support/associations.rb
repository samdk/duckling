RSpec::Matchers.define :belong_to do |association|
  match do |model|
    model = model.class if model.is_a? ActiveRecord::Base
    model.reflect_on_all_associations(:belongs_to).find { |a| a.name == association }
  end
end

RSpec::Matchers.define :have_many do |association|
  match do |model|
    model = model.class if model.is_a? ActiveRecord::Base
    model.reflect_on_all_associations(:has_many).find { |a| a.name == association }
  end
end

RSpec::Matchers.define :have_one do |association|
  match do |model|
    model = model.class if model.is_a? ActiveRecord::Base
    model.reflect_on_all_associations(:has_one).find { |a| a.name == association }
  end
end

RSpec::Matchers.define :have_and_belong_to_many do |association|
  match do |model|
    model = model.class if model.is_a? ActiveRecord::Base
    model.reflect_on_all_associations(:has_and_belongs_to_many).find { |a| a.name == association }
  end
end

RSpec::Matchers.define :serialize do |field, opts|
  field = field.to_s
  
  match do |model|
    model = model.class if model.is_a? ActiveRecord::Base
    if opts[:as]
      model.serialized_attributes[field] == opts[:as]
    else
      model.serialized_attributes.include? field
    end
  end
  
  failure_message_for_should do |model|
    model = model.class if model.is_a? ActiveRecord::Base
    "expected #{field} in #{model.serialized_attributes.keys.inspect}"
  end
end