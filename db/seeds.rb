# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Store.delete_all
Store.create(id: 1, symbol: 'GA', name: 'SKM Gdynia Główna', active: true)

User.delete_all
User.create(id: 1, email: 'admin@demo.pl', password: 'admin', first_name: 'Mr', last_name: 'Admin',
            active: true, current_store_id: 1)

Role.delete_all
Role.create([
  {id: 1, name: 'Admin', global: true},
  {id: 2, name: 'Owner', global: true},
  {id: 3, name: 'Manager', global: false},
  {id: 4, name: 'Barista', global: false},
])

UserRole.delete_all
UserRole.create([
  {user_id: 1, role_id: 1},
  {user_id: 1, role_id: 2},
  {user_id: 1, role_id: 3, store_id: 1}
])
