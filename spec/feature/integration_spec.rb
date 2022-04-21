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

RSpec.describe 'Sunny Day', type: :feature do
  before 'Init' do
    # create dummy event with privilleged account
    visit root_path
    mock_auth_hash("Isaac Yeang", "wjmckinley@tamu.edu")
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
  end

  context 'Events' do 
    scenario '- Successfully Created a User' do
      click_link 'Sign Out'
      # get normal-privillege user
      mock_auth_hash
      click_link 'Sign in with Google'

      fill_in 'First Name', with: 'tony'
      fill_in 'Last Name', with: 'hawk'
      fill_in 'user_class_year', with: 2020

      click_on 'Create User'
      click_link 'Sign in with Google'
      expect(page).to have_content('Welcome, tony!')
    end
    
    scenario '- Event Attributes Properly Showing' do 
      click_link 'Sign Out'
      mock_auth_hash
      click_link 'Sign in with Google'

      fill_in 'First Name', with: 'tony'
      fill_in 'Last Name', with: 'hawk'
      fill_in 'user_class_year', with: 2020

      click_on 'Create User'
      click_link 'Sign in with Google'
      click_link 'Events'
      expect(page).to have_content('Events')
      expect(page).to have_content('Title')
      expect(page).to have_content('Description')
      expect(page).to have_content('Date')
      expect(page).to have_content('Start Time (CST)')
      expect(page).to have_content('End Time (CST)')
    end
    
    it '- Events Properly Showing' do
      click_link 'Sign Out'
      mock_auth_hash
      click_link 'Sign in with Google'

      fill_in 'First Name', with: 'tony'
      fill_in 'Last Name', with: 'hawk'
      fill_in 'user_class_year', with: 2020

      click_on 'Create User'
      click_link 'Sign in with Google'
      click_link 'Events'
      expect(page).to have_content("it's pretty crazy")
      expect(page).to have_content('some crazy event')
      expect(page).to have_content('2020-11-15')
      visit '/events/toggle/1'
    end
  end

  context 'Unescalated Account Logging Attendance' do
    it '- Successfully Logged Attendance' do
      click_link 'Sign Out'
      mock_auth_hash
      click_link 'Sign in with Google'

      fill_in 'First Name', with: 'tony'
      fill_in 'Last Name', with: 'hawk'
      fill_in 'user_class_year', with: 2020

      click_on 'Create User'
      click_link 'Sign in with Google'
      visit root_path
      click_link 'Attendance'
      click_on 'New Attendance Record'
      select "it's pretty crazy", from: 'Event'
      fill_in 'Attend Time Start', with: '2:30pm'
      fill_in 'Attend Time End', with: '2:50pm'
      click_on 'Create Attendance'
  
      expect(page).to have_content("it's pretty crazy")
      expect(page).to have_content('tony hawk')
      expect(page).to have_content('2:30 pm')
      expect(page).to have_content('2:50 pm')
      expect(page).to have_content('false')
    end
  end

  context 'Escalated Account Logging Attendance' do
    it '- Successfully Logged Attendance' do
      visit root_path
      click_link 'Attendance'
      click_on 'New Attendance Record'
      select "it's pretty crazy", from: 'Event'
      fill_in 'Attend Time Start', with: '2:30pm'
      fill_in 'Attend Time End', with: '2:50pm'
      click_on 'Create Attendance'
  
      expect(page).to have_content("it's pretty crazy")
      expect(page).to have_content('Isaac Yeang')
      expect(page).to have_content('2:30 pm')
      expect(page).to have_content('2:50 pm')
      expect(page).to have_content('false')

      click_on 'Edit'
      fill_in 'Attend Time End', with: '5:50pm'
      click_on 'Update Attendance'
    end
  end

  context 'Announcement' do 
    it '- Successfully Created Announcement' do 
      visit root_path
      click_link 'Announcements'
      click_on 'New Announcement'

      fill_in 'Title', with: 'DANGER'
      fill_in 'Description', with: 'the flowers have finally attacked'

      click_on 'Create Announcement'

      expect(page).to have_content('DANGER')
      expect(page).to have_content('the flowers have finally attacked')

      click_link 'Back'

      visit root_path
      click_link 'Announcements'
      click_on 'Edit'
      fill_in 'Title', with: 'DANGER2'
      click_on 'Update Announcement'
      expect(page).to have_content('DANGER2')
    end
  end

  context 'Download' do 
    it 'Download CSV' do 
      visit root_path
      expect(page).to have_content('Download Report')
      click_link 'Download Report'
    end
  end
end

RSpec.describe 'Rainy Day', type: :feature do
  before 'Init' do
    # create dummy event with privilleged account
    visit root_path
    mock_auth_hash("Isaac Yeang", "wjmckinley@tamu.edu")
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
  end

  context 'Ensure Proper Privilleges' do
    it 'Try with unescalated account' do 
      click_link 'Sign Out'

      mock_auth_hash
      click_link 'Sign in with Google'

      fill_in 'First Name', with: 'tony'
      fill_in 'Last Name', with: 'hawk'
      fill_in 'user_class_year', with: 2020

      click_on 'Create User'
      click_link 'Sign in with Google'

      click_link 'Events'
      expect(page).not_to have_content('New Event')

      click_link 'Back'
      click_link 'Attendance'
      expect(page).to have_content('New Attendance Record')
      click_link 'Back'

      expect(page).not_to have_content('Manage Users')
      expect(page).not_to have_content('Download Report')
    end
  end

  scenario 'Event Invalid Inputs' do 
    click_link 'Events'
    click_on 'New Event'
    fill_in 'Title', with: ""
    fill_in 'Description', with: ''

    fill_in 'event_date', with: ''
    fill_in 'Event Time Start', with: ''
    fill_in 'Event Time End', with: ''
    click_on 'Create Event'

    expect(page).to have_content("Event time end can't be blank")
  end

  scenario 'Attendance Invalid Inputs' do 
    click_link 'Attendance'
    click_on 'New Attendance Record'
    select "", from: 'Event'
    fill_in 'Attend Time Start', with: ''
    fill_in 'Attend Time End', with: ''
    click_on 'Create Attendance'

    expect(page).to have_content("Must attend an event")
    
    select "it's pretty crazy", from: 'Event'
    click_on 'Create Attendance'
    expect(page).to have_content("Must set attendance times")

    fill_in 'Attend Time Start', with: '2:30 PM'
    click_on 'Create Attendance'
    expect(page).to have_content("Must set attendance times")

    fill_in 'Attend Time End', with: '5:30 PM'
    click_on 'Create Attendance'
    expect(page).to have_content("Attendance was successfully created.")
  end

  scenario 'Manage Users - No changes available to webmaster' do 
    click_link 'Manage Users'
    
    expect(page).not_to have_content("Edit")
    expect(page).not_to have_content("Destroy")
  end

  scenario 'Announcements Invalid Inputs' do 
    click_link 'Announcements'
    
    click_on 'New Announcement'
    fill_in 'Title', with: ''
    click_on 'Create Announcement'

    expect(page).to have_content("Title can't be blank")
  end
end
