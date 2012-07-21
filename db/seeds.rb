require 'set'
require 'ffaker'
require 'factory_girl'
FactoryGirl.find_definitions

20.times { FactoryGirl.create(:user) } 
5.times { FactoryGirl.create(:organization) }
3.times { FactoryGirl.create(:activation) }

# makes an activation, adds some users to it

section_names = %w[Medical Health Sanitation Grounds Food Shelter Government Public\ Relations Cleanup Construction Police Fire\ Department Volunteer\ Coordination Pets]

def make_section(name,activation)
  section = Section.new
  section.name = name
  section.description = [@update_text.split('. ').sample,''].sample
  section.users = @users.sample(1 + (rand * (@users.length - 10)))
  section.activation = activation
  save(section)
end
section_names.each {|n| make_section(n,a)}
@sections = Section.all
puts "#{@sections.length} sections created"

# set our own timestamps for updates
Update.record_timestamps = false
@current_time = Time.now - 7.days
total_update_count = 20
@base_interval = (Time.now - @current_time) / total_update_count
@current_count = 1

def make_random_update(activation,author)
  sentences = @update_text.split('. ').sort_by {rand}
  title = sentences.sample[0..(30 + rand * (sentences.length-30))]
  length = (rand * (sentences.length-2)).to_i
  body = sentences[0..length].join('. ')
  sections = @sections.sample(rand * @sections.length)
  u = activation.updates.build(author:author,title:title,body:body,sections:sections).authorize_with(author)
  @current_time = @current_time + @base_interval - (0..60).to_a.sample.minutes
  u.created_at = u.updated_at = @current_time
  save(u)
  @current_count += 1
end
total_update_count.times { make_random_update(a, @users.sample) }
@updates = Update.all
puts "#{@updates.length} updates created"

