require 'set'

def save(obj)
  unless obj.skipping_auth! { obj.save }
    puts obj.errors.full_messages
    raise Error
  end
end

#ActiveRecord::Base.logger = Logger.new(STDOUT)

# makes some users
first_names = %w[Jacob Isabella Ethan Sophia Michael Emma Jayden Olivia William Ava Alexander Emily Noah Abigail Daniel Madison Aiden Chloe Anthony Mia Joshua Addison Mason Elizabeth Christopher Ella Andrew Natalie David Samantha Matthew Alexis Logan Lily Elijah Grace James Hailey Joseph Alyssa Gabriel Lillian Benjamin Hannah Ryan Avery Samuel Leah Jackson Nevaeh John Sofia Nathan Ashley Jonathan Anna Christian Brianna Liam Sarah Dylan Zoe Landon Victoria Caleb Gabriella Tyler Brooklyn Lucas Kaylee Evan Taylor Gavin Layla Nicholas Allison Isaac Evelyn Brayden Riley Luke Amelia Angel Khloe Brandon Makayla Jack Aubrey Isaiah Charlotte Jordan Savannah Owen Zoey Carter Bella Connor Kayla Justin Alexa Jose Peyton Jeremiah Audrey Julian Claire Robert Arianna Aaron Julia Adrian Aaliyah Wyatt Kylie Kevin Lauren Hunter Sophie Cameron Sydney Zachary Camila Thomas Jasmine Charles Morgan Austin Alexandra Eli Jocelyn Chase Gianna Henry Maya Sebastian Kimberly Jason Mackenzie Levi Katherine Xavier Destiny Ian Brooke Colton Trinity Dominic Faith Juan Lucy Cooper Madelyn Josiah Madeline Luis Bailey Ayden Payton Carson Andrea Adam Autumn Nathaniel Melanie Brody Ariana Tristan Serenity Diego Stella Parker Maria Blake Molly Oliver Caroline Cole Genesis Carlos Kaitlyn Jaden Eva Jesus Jessica Alex Angelina Aidan Valeria Eric Gabrielle Hayden Naomi Bryan Mariah Max Natalia Jaxon Paige Brian Rachel]
last_names = %w[Smith Johnson Williams Jones Brown Davis Miller Wilson Moore Taylor Anderson Thomas Jackson White Harris Martin Thompson Garcia Martinez Robinson Clark Rodriguez Lewis Lee Walker Hall Allen Young Hernandez King Wright Lopez Hill Scott Green Adams Baker Gonzalez Nelson Carter Mitchell Perez Roberts Turner Phillips Campbell Parker Evans Edwards Collins Stewart Sanchez Morris Rogers Reed Cook Morgan Bell Murphy Bailey Rivera Cooper Richardson Cox Howard Ward Torres Peterson Gray Ramirez James Watson Brooks Kelly Sanders Price Bennett Wood Barnes Ross Henderson Coleman Jenkins Perry Powell Long Patterson Hughes Flores Washington Butler Simmons Foster Gonzales Bryant Alexander Russell Griffin Diaz Hayes Myers Ford Hamilton Graham Sullivan Wallace Woods Cole West Jordan Owens Reynolds Fisher Ellis Harrison Gibson Mcdonald Cruz Marshall Ortiz Gomez Murray Freeman Wells Webb Simpson Stevens Tucker Porter Hunter Hicks Crawford Henry Boyd Mason Morales Kennedy Warren Dixon Ramos Reyes Burns Gordon Shaw Holmes Rice Robertson Hunt Black Daniels Palmer Mills Nichols Grant Knight Ferguson Rose Stone Hawkins Dunn Perkins Hudson Spencer Gardner Stephens Payne Pierce Berry Matthews Arnold Wagner Willis Ray Watkins Olson Carroll Duncan Snyder Hart Cunningham Bradley Lane Andrews Ruiz Harper Fox Riley Armstrong Carpenter Weaver Greene Lawrence Elliott Chavez Sims Austin Peters Kelley Franklin Lawson]
 
@user_index = 0
@used_emails = Set.new

def make_user(first_name,last_name)
  u = User.new
  u.first_name = first_name
  u.last_name = last_name
  u.initial_email = email = "#{first_name[0]}#{last_name}".downcase
  u.initial_email = "#{email}#{@used_emails.include?(email) ? @user_index : ''}@example.com"
  u.password = u.password_confirmation = 'testtest'
  u.phone_numbers['Desk'] = "555-555-01%02d" % (@user_index % 100)
  u.phone_numbers['Cell'] = "555-555-02%02d" % (@user_index * 2 % 100)
  save(u)
  
  @used_emails << u.initial_email  
  @user_index += 1
end

make_user("Test","User")
30.times do |i|
  fn = first_names.sample
  ln = last_names.sample
  make_user(fn,ln)
end
@users = User.all

@users.each {|user| puts user.errors.inspect unless user.valid?}

puts "#{@users.length} users created"

organization_names = %w[AARP\ Foundation Adventist\ Development\ &\ Relief\ Agency\ International Air\ Compassion\ America Alley\ Cat\ Allie Alley Cat Rescue AmeriCares America\ Responds\ with\ Love,\ Inc. America's\ Second\ Harvest American\ Cancer\ Society American\ Humane\ Association American\ Kidney\ Fund American\ Lung\ Association American\ Red\ Cross Ananda\ Marga\ Universal\ Relief\ Team,\ Inc. Angel\ Flight Angel\ Flight\ America ASPCA:\ American\ Society\ for\ the\ Prevention\ of\ Cruelty\ to\ Animals Association\ of\ Gospel\ Rescue\ Missions Baptist\ World\ Alliance Big\ Brothers\ Big\ Sisters\ of\ America Brother's\ Brother\ Foundation Catholic\ Charities\ USA Children's\ Miracle\ Networ Children's\ Network\ International Child\ Welfare\ League\ of\ America Christian\ Appalachian\ Project Christian\ Reformed\ World\ Relief\ Committee Church\ World\ Service/CROP CitiHope\ International,\ Inc. Coast\ Guard\ Foundation Cystic\ Fibrosis\ Foundation Days\ End\ Farm\ Horse\ Rescu Direct\ Relief\ International Disabled\ American\ Veterans Dogs\ for\ Deaf\ and\ Disabled\ Americans Dollars\ for\ Scholars Easter\ Seals FARM\ AID Federal\ Employee\ Education\ and\ Assistance\ Fund Feed\ The\ Children First\ Book Gifts\ In\ Kind\ International Giving\ Children\ Hope Greyhound\ Foundation Habitat\ for\ Humanity\ International Heart\ To\ Heart\ International Hearts\ United\ for\ Animals Human\ Care\ Charities\ of\ America Humane\ Society\ of\ the\ United\ States,\ The Huntington's\ Disease\ Society\ of\ America In\ Defense\ of\ Animals International\ Aid,\ Inc. International\ Association\ for\ Human\ Values International\ Fund\ for\ Animal\ Welfare International\ Medical\ Corps International\ Orthodox\ Christian\ Charities International\ Relief\ &\ Development,\ Inc. International\ Relief\ Teams International\ Rescue\ Committee Leukemia\ &\ Lymphoma\ Society,\ The Lions\ Clubs\ International\ Foundation MADRE,\ Inc March\ of\ Dimes\ Birth\ Defects\ Foundation Medical\ Teams\ International Mercy\ Corps Mercy\ Medical\ Airlift Mercy-USA\ for\ Aid\ and\ Development,\ Inc. Mr.\ Holland's\ Opus\ Foundation Operation\ Blessing\ International\ Relief\ and\ Development\ Corp. Operation\ USA Oxfam\ America PETA:\ People\ for\ the\ Ethical\ Treatment\ of\ Animals PETsMART\ Charities Points\ of\ Light\ Foundation Project\ HOP ProLiteracy\ Worldwide Rebuilding\ Together,\ Inc. Salvation\ Army\ World\ Service\ Office Samaritan's\ Purse Save\ the\ Children Spina\ Bifida\ Association\ of\ America St.\ Jude\ Children's\ Research\ Hospital Society\ of\ St.\ Vincent\ de\ Paul\ Council\ of\ the\ United\ States Starlight\ Starbright\ Children's\ Foundation Trickle\ Up\ Program,\ Inc. United\ Animal\ Nations United\ Cerebral\ Palsy\ Associations United\ Methodist\ Committee\ on\ Relief United\ Way\ of\ America Volunteers\ of\ America Water\ Missions\ International World\ Hope\ International,\ Inc. World\ Vision]
def make_organization(name)
  o = Organization.new
  o.name = name
  o.users = @users[1..-1].sample(1 + (rand * (@users.length - 10)))
  
  User.first.administrate(o)
  save(o)
end
organization_names[0..5].each {|n| make_organization(n)}
@orgs = Organization.all
puts "#{@orgs.length} organizations created"

# makes an activation, adds some users to it
a = Activation.new
a.title = "Super Scary Snowstorm"
a.active = true
a.description = "There was a really scary snowstorm and we need to make it less scary."
a.organizations = @orgs
a.users = @users
save(a)

@update_text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur. Donec ut libero sed arcu vehicula ultricies a non tortor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ut gravida lorem. Ut turpis felis, pulvinar a semper sed, adipiscing id dolor. Pellentesque auctor nisi id magna consequat sagittis. Curabitur dapibus enim sit amet elit pharetra tincidunt feugiat nisl imperdiet. Ut convallis libero in urna ultrices accumsan. Donec sed odio eros. Donec viverra mi quis quam pulvinar at malesuada arcu rhoncus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In rutrum accumsan ultricies. Mauris vitae nisi at sem facilisis semper ac in est. \nVivamus fermentum semper porta. Nunc diam velit, adipiscing ut tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi diam iaculis velit, id fringilla sem nunc vel mi. Nam dictum, odio nec pretium volutpat, arcu ante placerat erat, non tristique elit urna et turpis. Quisque mi metus, ornare sit amet fermentum et, tincidunt et orci. Fusce eget orci a orci congue vestibulum. Ut dolor diam, elementum et vestibulum eu, porttitor vel elit. Curabitur venenatis pulvinar tellus gravida ornare. Sed et erat faucibus nunc euismod ultricies ut id justo. Nullam cursus suscipit nisi, et ultrices justo sodales nec. Fusce venenatis facilisis lectus ac semper. Aliquam at massa ipsum. Quisque bibendum purus convallis nulla ultrices ultricies. Nullam aliquam, mi eu aliquam tincidunt, purus velit laoreet tortor, viverra pretium nisi quam vitae mi. Fusce vel volutpat elit. Nam sagittis nisi dui.\nSuspendisse lectus leo, consectetur in tempor sit amet, placerat quis neque. Etiam luctus porttitor lorem, sed suscipit est rutrum non. Curabitur lobortis nisl a enim congue semper. Aenean commodo ultrices imperdiet. Vestibulum ut justo vel sapien venenatis tincidunt. Phasellus eget dolor sit amet ipsum dapibus condimentum vitae quis lectus. Aliquam ut massa in turpis dapibus convallis. Praesent elit lacus, vestibulum at malesuada et, ornare et est. Ut augue nunc, sodales ut euismod non, adipiscing vitae orci. Mauris ut placerat justo. Mauris in ultricies enim. Quisque nec est eleifend nulla ultrices egestas quis ut quam. Donec sollicitudin lectus a mauris pulvinar id aliquam urna cursus. Cras quis ligula sem, vel elementum mi. Phasellus non ullamcorper urna."
section_names = %w[Medical Health Sanitation Grounds Food Shelter Government Public\ Relations Cleanup Construction Police Fire\ Department Volunteer\ Coordination Pets]
def make_group(name,activation)
  section = Section.new
  section.name = name
  section.description = [@update_text.split('. ').sample,''].sample
  section.users = @users.sample(1 + (rand * (@users.length - 10)))
  section.activation = activation
  puts save(section)
end
section_names.each {|n| make_group(n,a)}
@sections = Section.all
puts "#{@sections.length} groups created"

# set our own timestamps for updates
ActiveRecord::Base.record_timestamps = false
@current_time = Time.now - 7.days
total_update_count = 50
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
total_update_count.times { make_random_update(a,@users.sample) }

50.times { make_random_update(a,@users.sample) }
@updates = Update.all
puts "#{@updates.length} updates created"
# re-enable timestamping
ActiveRecord::Base.record_timestamps = true

