# location: spec/unit/unit_spec.rb
require 'rails_helper'

RSpec.describe Announcement, type: :model do
  subject do
    described_class.new(title: 'plant attack', description: 'plants are attacking', posted_on: '3rd Feb 2021 04:05:06+03:30', user_id: 0,
                        event_id: 1)
  end

  it 'is not valid without a title' do
    subject.title = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a posted date' do
    subject.posted_on = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a user_id' do
    subject.user_id = nil
    expect(subject).not_to be_valid
  end
end

RSpec.describe Attendance do
  subject do
    @e = Event.new(id: 1)
    @e.save
    described_class.new(id:1, user_id: 1, attend_time_start: '1:00', attend_time_end: '2:00', plans_to_attend: true, created_at: '3/27/22 1:00', updated_at: '3/28/22 2:00', event_id: @e.id)

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  
    it 'is not valid without an event id' do
      subject.event_id = nil
      expect(subject).not_to be_valid
    end
  
    it 'is valid without an attend time start' do
      subject.attend_time_start = nil
      expect(subject).to be_valid
    end
  
    it 'is valid without an attend time end' do
      subject.attend_time_end = nil
      expect(subject).to be_valid
    end
  end
end

RSpec.describe Event, type: :model do
  subject do
    described_class.new(title: 'joe dev world', description: 'welcome to joe dev world!', date: '2021-01-01', event_time_start: '12:00',
                        event_time_end: '13:00')
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a title' do
    subject.title = nil
    expect(subject).not_to be_valid
  end

  it 'is valid without a description' do
    subject.description = nil
    expect(subject).to be_valid
  end

  it 'is not valid without a date' do
    subject.date = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without an event_time_start' do
    subject.event_time_start = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without an event_time_end' do
    subject.event_time_end = nil
    expect(subject).not_to be_valid
  end
end

RSpec.describe User, type: :model do
  subject do
    described_class.new(email: 'user@tamu.edu', first_name: 'User', last_name: 'McUser', class_year: 1999)
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without an email' do
    subject.email = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a first name' do
    subject.first_name = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid with unapproved characters in first name' do
    subject.first_name = '420'
    expect(subject).not_to be_valid
  end

  it 'is not valid without a last name' do
    subject.last_name = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid with unapproved characters in last name' do
    subject.last_name = '69'
    expect(subject).not_to be_valid
  end

  it 'is not valid without class year' do
    subject.class_year = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid with class year less than 1876' do
    subject.class_year = 400
    expect(subject).not_to be_valid
  end
end

RSpec.describe Permission, type: :model do
  subject do
    described_class.new(title: 'plant appraiser', is_admin: true, create_modify_events: true, create_modify_announcements: true,
                        view_all_attendances: true)
  end
end
