require 'rails_helper'

RSpec.describe 'User cancels a pending request', js: true do
  let!(:user) { create(:user, net_id: 'bob123@musc.edu') }
  login_user_for_each_test('bob123@musc.edu')

  let!(:request) { create(:sparc_request, :pending, user: user) }

  it 'should cancel the request' do
    visit sparc_requests_path

    find('.cancel-request').click
    click_button I18n.t(:confirm)[:confirm]
    wait_for_ajax

    expect(SparcRequest.first.status).to eq(I18n.t(:requests)[:statuses][:cancelled])
    expect(page).to have_content(SPARC::Protocol.first.identifier)
    expect(page).to have_selector('.request-status', text: I18n.t(:requests)[:statuses][:cancelled])
  end
end
