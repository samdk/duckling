# makes some users
first_names = %w(Emily Sarah Brianna Samantha Hailey Jacob Michael Matthew Nicholas Christoper)
last_names = %w(Smith Johnson Williams Jones Brown Rodriguez Davis Miller Wilson Garcia)

def make_user(first_name,last_name)
  u = User.new
  u.first_name = first_name
  u.last_name = last_name
  u.email_addresses << "#{first_name[0]}#{last_name}@example.com"
  u.password = 'test'
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


