require 'rails_helper'

RSpec.describe 'User edits a pending request', js: true do
  let!(:user) { create(:user, net_id: 'bob123@musc.edu') }
  login_user_for_each_test('bob123@musc.edu')

  let!(:request) { create(:sparc_request, :draft, user: user, line_item_count: 1) }

  it 'should update the request' do
    visit sparc_requests_path

    find('.edit-draft-request').click
    wait_for_ajax

    fill_in 'sparc_request_specimen_requests_attributes_0_number_of_specimens_requested', with: 100
    fill_in 'sparc_request_specimen_requests_attributes_0_minimum_sample_size', with: '1mL'

    click_button I18n.t(:requests)[:form][:save_as_draft]
    wait_for_ajax

    expect(request.line_items.first.reload.number_of_specimens_requested).to eq(100)
    expect(request.line_items.first.reload.minimum_sample_size).to eq('1mL')
  end
end
