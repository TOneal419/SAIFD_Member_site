# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(id: 0, email: 'test@tamu.edu', first_name: 'blah', last_name: 'test', report_rate: 'Disabled', class_year: 2024, permission_id: 0, created_at: '3/3/2022', updated_at: '3/3/2022')
Permission.create(user_id: 0, is_admin: true, create_modify_events: true, create_modify_announcements: true, view_all_attendances: true, created_at: '3/3/2022', updated_at: '3/3/2022')