['admin', 'user'].each do |role|
  Role.find_or_create_by({name: role})
end

User.create({:email => "adm@adm.com", :name => "Admin", :password => "a1s2d3f4", :password_confirmation => "a1s2d3f4", :role => Role.find_by_name('admin')})