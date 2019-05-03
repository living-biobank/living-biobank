require 'rails_helper'

RSpec.describe 'User begins a new request', js: true do
  login_user_for_each_test

  let!(:primary_pi) { create(:sparc_identity) }
  let!(:service) { create(:sparc_service) }

  before :each do
    ENV['SERVICE_ID'] = SPARC::Service.all.ids.join(',')
  end

  it 'should create the new request' do
    visit sparc_requests_path

    click_button I18n.t(:requests)[:create]
    click_button I18n.t(:requests)[:create_confirm][:confirm]

    expect(page).to have_selector('#requestFormModal', wait: 10)
    fill_in 'sparc_request_protocol_attributes_title', with: 'A Not So Short Title'
    fill_in 'sparc_request_protocol_attributes_short_title', with: 'A Short Title'
    bootstrap_select '#sparc_request_protocol_attributes_funding_status', SPARC::PermissibleValue.get_hash('funding_status')['funded']
    bootstrap_select '#sparc_request_protocol_attributes_funding_source', SPARC::PermissibleValue.get_hash('funding_source')['federal']
    fill_in 'sparc_request_protocol_attributes_start_date', with: Date.today.strftime('%m/%d/%Y')
    fill_in 'sparc_request_protocol_attributes_end_date', with: (Date.today + 1.month).strftime('%m/%d/%Y')
    bootstrap_typeahead '#primary_pi_search', primary_pi.ldap_uid

    bootstrap_select '#sparc_request_line_items_attributes_0_service_id', service.name
    bootstrap_select '#sparc_request_line_items_attributes_0_service_source'
    bootstrap_select '#sparc_request_line_items_attributes_0_query_name'
    fill_in 'sparc_request_line_items_attributes_0_number_of_specimens_requested', with: 5
    fill_in 'sparc_request_line_items_attributes_0_minimum_sample_size', with: '1mL'

    click_button I18n.t(:requests)[:form][:submit]
    wait_for_ajax

    expect(page).to_not have_selector('#requestFormModal', wait: 10)

    expect(SparcRequest.count).to eq(1)
    expect(SPARC::Protocol.count).to eq(1)
    expect(SPARC::LineItem.count).to eq(1)
    expect(page).to have_content(SPARC::Protocol.first.identifier.truncate(60))
    expect(page).to have_selector('.request-status', text: I18n.t(:requests)[:statuses][:pending])
  end
end
