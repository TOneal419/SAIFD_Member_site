# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



# User.create(id: -1, email: 'test@tamu.edu', first_name: 'blah', last_name: 'test', report_rate: 'Disabled', class_year: 2024, permission_id: -1, created_at: '3/3/2022', updated_at: '3/3/2022')
# Permission.create(user_id: -1, is_admin: true, create_modify_events: true, create_modify_announcements: true, view_all_attendances: true, created_at: '3/3/2022', updated_at: '3/3/2022')

# User.create(id: -2, email: 'wjmckinley@tamu.edu', first_name: 'blah', last_name: 'test', report_rate: 'Disabled', class_year: 2024, permission_id: -2, created_at: '3/3/2022', updated_at: '3/3/2022')
# Permission.create(user_id: -2, is_admin: true, create_modify_events: true, create_modify_announcements: true, view_all_attendances: true, created_at: '3/3/2022', updated_at: '3/3/2022')

# User.create(id: -3, email: 'bill.mckinley@ag.tamu.edu', first_name: 'blah', last_name: 'test', report_rate: 'Disabled', class_year: 2024, permission_id: -3, created_at: '3/3/2022', updated_at: '3/3/2022')
# Permission.create(user_id: -3, is_admin: true, create_modify_events: true, create_modify_announcements: true, view_all_attendances: true, created_at: '3/3/2022', updated_at: '3/3/2022')

# Event.create(id: 1, title: 'made by test', description: 'tmp', date:'3/22/2022', event_time_start: '3:00pm', event_time_end: '4:00pm', created_at: '3/3/2022', updated_at: '3/3/2022')
# Announcement.create(id: 1, title: 'test announce', description: 'tmp', posted_on:'3/22/2022', user_id: -1, event_id: 1, created_at: '3/3/2022', updated_at: '3/3/2022')
# Attendance.create(id: 1, event_id: 1, user_id: -1, attend_time_start: nil, attend_time_end: nil, plans_to_attend: false, created_at: '3/3/2022', updated_at: '3/3/2022')
# Attendance.create(id: 2, event_id: 1, user_id: -2, attend_time_start: nil, attend_time_end: nil, plans_to_attend: true, created_at: '3/3/2022', updated_at: '3/3/2022')
# Attendance.create(id: 3, event_id: 1, user_id: -3, attend_time_start: nil, attend_time_end: nil, plans_to_attend: false, created_at: '3/3/2022', updated_at: '3/3/2022')