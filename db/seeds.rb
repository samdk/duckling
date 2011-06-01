# makes some users
first_names = %w[Emily Sarah Brianna Samantha Hailey Jacob Michael Matthew Nicholas Christoper]
last_names = %w[Smith Johnson Williams Jones Brown Rodriguez Davis Miller Wilson Garcia]

def make_user(first_name,last_name)
  u = User.new
  u.first_name = first_name
  u.last_name = last_name
  u.email_addresses << "#{first_name[0]}#{last_name}@example.com"
  u.password = 'testtest'
  u.save
end

make_user("Test","User")
make_user("John","Smith")
first_names.zip(last_names).each { |fn,ln| make_user(fn,ln) }

# makes an activation, adds some users to it
a = Activation.new
a.title = "Super Scary Snowstorm"
a.description = "There was a really scary snowstorm and we need to make it less scary."
a.users = User.all[0..7]
a.save

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