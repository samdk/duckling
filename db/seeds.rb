# create some users...
u = User.new
u.first_name = 'John'
u.last_name = 'Smith'
u.email_addresses << 'jsmith@example.com'
u.password = 'test'
u.save

