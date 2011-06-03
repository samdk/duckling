require 'set'

# makes some users
first_names = %w[Emily Sarah Brianna Samantha Hailey Jacob Michael Matthew Nicholas Christoper]
last_names = %w[Smith Johnson Williams Jones Brown Rodriguez Davis Miller Wilson Garcia]

user_index = 0
used_emails = Set.new

def make_user(first_name,last_name)
  u = User.new
  u.first_name = first_name
  u.last_name = last_name
  email = "#{first_name[0]}#{last_name}"
  email = "#{email}#{used_emails.include?(email) ? '' : user_index}@example.com"
  used_emails.add(email)
  u.email_addresses << email
  u.password = u.password_confirmation = 'testtest'
  u.phone_numbers['Desk'] = "555-555-01#{user_index % 100}"
  u.phone_numbers['Cell'] = "555-555-01#{user_index * 2 % 100}"
  unless u.save
    puts "0 #{u.errors}"
  end
end

make_user("Test","User")
make_user("John","Smith")
first_names.zip(last_names).each { |fn,ln| make_user(fn,ln) }

# makes an activation, adds some users to it
a = Activation.new
a.title = "Super Scary Snowstorm"
a.active = true
a.description = "There was a really scary snowstorm and we need to make it less scary."
a.users = User.all[0..7]
unless a.save; puts "1 #{a.errors}"; end

a.updates.create author: User.first, title: 'Heavy Winds', body: 'People are falling over! It is awful.'
a.updates.create author: User.first, title: 'Lots of Snow', body: 'People are stuck in the snow! It is awful.'
a.updates.create author: User.first, title: 'There are icicles on my beard and it is awful', body: 'If I had hands, this would\'t be a big deal.'
a.updates.create author: User.first, title: 'Lorem Ipsum', body: <<-BODY
Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Pellentesque porttitor commodo venenatis. Vestibulum id risus massa.

Cras a neque mi. Sed non vehicula mi.
Mauris ut ipsum non nisi ultrices posuere eu vitae massa.
Maecenas porta malesuada dui, pharetra volutpat sem tempor sed.

Donec nec lacus tortor, id lacinia mauris. Mauris vitae turpis sapien.
Duis at varius lacus. Fusce tristique sem non nisi tempor tincidunt.
Sed turpis enim, accumsan quis blandit in, placerat vel diam.
Ut et sagittis nisi. Integer nec orci sapien, a aliquam leo.
Suspendisse sit amet purus enim. Pellentesque ac erat ut massa blandit facilisis.
Cras sollicitudin venenatis eros vel ultrices. Fusce vitae tortor id nibh rutrum 
scelerisque sed vitae velit. Integer a velit non risus volutpat dignissim et sit amet
sem. Mauris non suscipit ligula.
BODY
a.updates.create author: User.first, title: 'Don\'t Stop Believing', body: '<strong>b</strong>'

o = Organization.new
o.name = "Rescuers"
o.users = User.all[1..-1]
o.administrators << User.first
unless o.save; puts "2 #{o.errors}"; end

def make_group(name,description,users,activation)
  g = Group.new
  g.name = name
  g.description = description
  g.users = users
  g.groupable = activation
  unless g.save; puts "3 #{g.save}"; end
end

make_group("Awesome People","A group for awesome people",User.all[0..3],Activation.first)
make_group("Other People","A group for non-awesome people",User.all[4..6],Activation.first)

