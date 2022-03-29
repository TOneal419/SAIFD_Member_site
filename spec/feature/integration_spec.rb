# location: spec/feature/integration_spec.rb
require 'rails_helper'
require 'rspec/rails'

def mock_auth_hash(full_name = 'tony hawk', email = 'tony@tamu.edu')
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: (Random.rand(999999999) + 100000000).to_s,
    info: {
      name: full_name,
      email: email
    },
    credentials: {
      token: '308710543738-t6dp4sal56ghupflaaud23spm9vqh53h.apps.googleusercontent.com',
      secret: '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'
    }
  })
end

RSpec.describe 'Sunny Day Events', type: :feature do
  before 'Init' do
    # create dummy event with privilleged account
    visit root_path
    mock_auth_hash("Isaac Yeang", "isaacy13@tamu.edu")
    click_link 'Sign in with Google'

    fill_in 'First Name', with: 'Isaac'
    fill_in 'Last Name', with: 'Yeang'
    fill_in 'user_class_year', with: 2022
    click_on 'Create User'
    click_link 'Sign in with Google'
    click_link 'Events'

    click_on 'New Event'
    fill_in 'Title', with: "it's pretty crazy"
    fill_in 'Description', with: 'some crazy event'

    fill_in 'event_date', with: '2020/11/15'
    fill_in 'Event Time Start', with: '2:30 PM'
    fill_in 'Event Time End', with: '5:50 PM'
    click_on 'Create Event'
    click_link 'Back'
    click_link 'Sign Out'

    # get normal-privillege user
    mock_auth_hash
    click_link 'Sign in with Google'

    fill_in 'First Name', with: 'tony'
    fill_in 'Last Name', with: 'hawk'
    fill_in 'user_class_year', with: 2020

    click_on 'Create User'
    click_link 'Sign in with Google'
  end

  scenario '- Successfully Created a User' do
    expect(page).to have_content('Welcome, tony!')
  end
  
  scenario '- Proper Privilleges' do
    click_link 'Events'
    expect(page).not_to have_content('New Event')
  end
  
  scenario '- Event Attributes Properly Showing' do 
    click_link 'Events'
    expect(page).to have_content('Events')
    expect(page).to have_content('Title')
    expect(page).to have_content('Description')
    expect(page).to have_content('Date')
    expect(page).to have_content('Start Time (CST)')
    expect(page).to have_content('End Time (CST)')
  end
  
  it '- Events Properly Showing' do
    click_link 'Events'
    expect(page).to have_content("it's pretty crazy")
    expect(page).to have_content('some crazy event')
    expect(page).to have_content('2020-11-15')
  end
  
end

# RSpec.describe 'Log attendance', type: :feature do
#   it 'valid inputs' do
#     visit root_path
#     mock_auth_hash
#     click_link 'Sign in with Google'

#     fill_in 'First Name', with: 'tony'
#     fill_in 'Last Name', with: 'hawk'
#     fill_in 'user_class_year', with: 2020

#     click_on 'Create User'
#     click_link 'Sign in with Google'

#     expect(page).to have_content('Welcome, tony!')

#     click_link 'Events'
#     click_on 'New Event'


#     fill_in 'Title', with: "it's pretty crazy"
#     fill_in 'Description', with: 'some crazy event'

#     fill_in 'event_date', with: '2020/11/15'
#     fill_in 'Event Time Start', with: '2:30 PM'
#     fill_in 'Event Time End', with: '5:50 PM'
#     click_on 'Create Event'

#     click_link 'Back'

#     click_link 'Log Attendance Record'
#     select "it's pretty crazy", from: 'Event'
#     fill_in 'Attend time start', with: '1:15'
#     fill_in 'Attend time end', with: '2:50'
#     click_on 'Create Attendance'

#     expect(page).to have_content("it's pretty crazy")
#     expect(page).to have_content('tony hawk')
#     expect(page).to have_content('1:15 am')
#     expect(page).to have_content('2:50 am')
#     expect(page).to have_content('false')
#   end
# end

# RSpec.describe 'Create announcement', type: :feature do
#   it 'valid inputs' do
#     visit root_path
#     mock_auth_hash
#     click_link 'Sign in with Google'

#     fill_in 'First Name', with: 'tony'
#     fill_in 'Last Name', with: 'hawk'
#     fill_in 'user_class_year', with: 2020

#     click_on 'Create User'
#     click_link 'Sign in with Google'

#     expect(page).to have_content('Welcome, tony!')

#     click_link 'Events'
#     click_on 'New Event'

#     fill_in 'Title', with: "it's pretty crazy"
#     fill_in 'Description', with: 'some crazy event'

#     fill_in 'event_date', with: '2020/11/15'
#     fill_in 'Event Time Start', with: '2:30 PM'
#     fill_in 'Event Time End', with: '5:50 PM'
#     click_on 'Create Event'
#     click_link 'Back'

#     click_link 'Make Announcement'

#     fill_in 'Title', with: 'DANGER'
#     fill_in 'Description', with: 'the flowers have finally attacked'

#     select '2022', from: 'announcement_posted_on_1i'
#     select 'February', from: 'announcement_posted_on_2i'
#     select '12', from: 'announcement_posted_on_3i'
#     select '11', from: 'announcement_posted_on_4i'
#     select '45', from: 'announcement_posted_on_5i'
#     click_on 'Create Announcement'

#     expect(page).to have_content('DANGER')
#     expect(page).to have_content('the flowers have finally attacked')
#     expect(page).to have_content('11:45 am')
#   end
# end
