require 'rails_helper'

RSpec.describe 'User saves a request as draft', js: true do
  login_user_for_each_test

  it 'should save the request as a draft' do
    visit sparc_requests_path

    click_button I18n.t(:requests)[:create]
    click_button I18n.t(:requests)[:create_confirm][:confirm]

    expect(page).to have_selector('#requestFormModal', wait: 10)
    fill_in 'sparc_request_protocol_attributes_title', with: 'A Not So Short Title'
    fill_in 'sparc_request_protocol_attributes_short_title', with: 'A Short Title'

    click_button I18n.t(:requests)[:form][:save_as_draft]
    wait_for_ajax

    expect(SparcRequest.count).to eq(1)
    expect(SparcRequest.first.status).to eq(I18n.t(:requests)[:statuses][:draft])
    expect(page).to have_selector('.draft-request')
    expect(page).to have_content(SparcRequest.first.identifier.truncate(60))
  end
end
