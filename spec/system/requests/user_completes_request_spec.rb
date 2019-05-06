require 'rails_helper'

RSpec.describe 'User completes an "In Process" request', js: true do
  let!(:user) { create(:user, :honest_broker, net_id: 'bob123@musc.edu') }
  login_user_for_each_test('bob123@musc.edu')

  let!(:request) { create(:sparc_request, :in_process, user: user) }

  it 'should complete the request' do
    visit sparc_requests_path

    find('.complete-request').click
    wait_for_ajax

    expect(SparcRequest.first.status).to eq(I18n.t(:requests)[:statuses][:completed])
    expect(page).to have_content(SPARC::Protocol.first.identifier)
    expect(page).to have_selector('.request-status', text: I18n.t(:requests)[:statuses][:completed])
  end
end
