require 'rails_helper'

RSpec.describe 'permissions/index', type: :view do
  before do
    assign(:permissions, [
             Permission.create!(
               permission_id: 2,
               title: 'Title',
               is_admin: false,
               create_modify_events: false,
               create_modify_announcements: false,
               view_all_attendances: false
             ),
             Permission.create!(
               permission_id: 2,
               title: 'Title',
               is_admin: false,
               create_modify_events: false,
               create_modify_announcements: false,
               view_all_attendances: false
             )
           ])
  end

  it 'renders a list of permissions' do
    render
    assert_select 'tr>td', text: 2.to_s, count: 2
    assert_select 'tr>td', text: 'Title'.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
  end
end
