# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin_user = User.create( email: 'admin@cau.ac.kr', name: '관리자', password: 'masterofcau', status: true, remember_created_at: Time.now )
Hakboo.create( name: '기타')
admin_user.add_role :admin