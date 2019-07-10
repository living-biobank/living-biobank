require 'rails_helper'

RSpec.describe 'User begins a new request', js: true do
  login_user_for_each_test

  let!(:primary_pi) { create(:sparc_identity) }
  let!(:service)    { create(:sparc_service) }

  before :each do
    ENV['SERVICE_ID'] = SPARC::Service.all.ids.join(',')
  end

  # Enabled by default (See `spec/support/rmid.rb`)
  context 'with Research Master ID enabled' do
    context 'and with an existing RMID' do
      context 'and with an existing SPARC protocol' do
        before :each do
          @protocol = create(:sparc_protocol, research_master_id: 1)
        end

        it 'should fill in the RMID title and short title and remaining SPARC protocol fields' do
          start_new_request

          find('#sparc_request_protocol_attributes_research_master_id').send_keys('1')
          wait_for_ajax

          expect(page).to have_field('sparc_request[protocol_attributes][title]', with: 'A long title')

          fill_in_line_item(service)

          click_button I18n.t(:requests)[:form][:submit]
          wait_for_ajax

          expect(page).to_not have_selector('#requestFormModal', wait: 10)

          expect(SparcRequest.count).to eq(1)
          expect(SPARC::Protocol.count).to eq(1)
          expect(page).to have_content(@protocol.reload.identifier.truncate(60))
        end
      end

      context 'but without an existing SPARC protocol' do
        it 'should only fill in the RMID title and short title' do
          start_new_request

          find('#sparc_request_protocol_attributes_research_master_id').send_keys('1')
          wait_for_ajax
          expect(page).to have_field('sparc_request[protocol_attributes][title]', with: 'A long title')

          bootstrap_select '#sparc_request_protocol_attributes_funding_status', SPARC::PermissibleValue.get_hash('funding_status')['funded']
          bootstrap_select '#sparc_request_protocol_attributes_funding_source', SPARC::PermissibleValue.get_hash('funding_source')['federal']
          fill_in 'sparc_request_protocol_attributes_start_date', with: Date.today.strftime('%m/%d/%Y')
          fill_in 'sparc_request_protocol_attributes_end_date', with: (Date.today + 1.month).strftime('%m/%d/%Y')
          bootstrap_typeahead '#primary_pi_search', primary_pi.ldap_uid

          fill_in_line_item(service)

          click_button I18n.t(:requests)[:form][:submit]
          wait_for_ajax

          expect(page).to_not have_selector('#requestFormModal', wait: 10)

          expect(SparcRequest.count).to eq(1)
          expect(SPARC::Protocol.count).to eq(1)
          expect(page).to have_content(SPARC::Protocol.first.identifier.truncate(60))
        end
      end
    end

    context 'but without an existing RMID' do
      before :each do
        stub_rmid(has_record: false)
      end

      it 'should display an error' do
        start_new_request

        find('#sparc_request_protocol_attributes_research_master_id').send_keys('1')
        expect(page).to have_content(I18n.t(:requests)[:form][:subtext][:rmid_not_found], wait: 5)
      end
    end
  end

  context 'with Research Master ID disabled' do
    before :each do
      stub_rmid(enabled: false)
    end

    context 'and with an existing SPARC protocol' do
      before :each do
        @protocol = create(:sparc_protocol)
      end

      it 'should fill in the Protocol fields' do
        start_new_request
        bootstrap_typeahead '#protocol_search', @protocol.short_title
        
        fill_in_line_item(service)

        click_button I18n.t(:requests)[:form][:submit]
        wait_for_ajax

        expect(page).to_not have_selector('#requestFormModal', wait: 10)

        expect(SparcRequest.count).to eq(1)
        expect(SPARC::Protocol.count).to eq(1)
        expect(page).to have_content(@protocol.reload.identifier.truncate(60))
      end
    end

    context 'but without an existing SPARC protocol' do
      it 'should require the user to fill in all fields manually' do
        start_new_request

        fill_in 'sparc_request_protocol_attributes_title', with: 'A Not So Short Title'
        fill_in 'sparc_request_protocol_attributes_short_title', with: 'A Short Title'
        bootstrap_select '#sparc_request_protocol_attributes_funding_status', SPARC::PermissibleValue.get_hash('funding_status')['funded']
        bootstrap_select '#sparc_request_protocol_attributes_funding_source', SPARC::PermissibleValue.get_hash('funding_source')['federal']
        fill_in 'sparc_request_protocol_attributes_start_date', with: Date.today.strftime('%m/%d/%Y')
        fill_in 'sparc_request_protocol_attributes_end_date', with: (Date.today + 1.month).strftime('%m/%d/%Y')
        bootstrap_typeahead '#primary_pi_search', primary_pi.ldap_uid

        fill_in_line_item(service)

        click_button I18n.t(:requests)[:form][:submit]
        wait_for_ajax

        expect(page).to_not have_selector('#requestFormModal', wait: 10)

        expect(SparcRequest.count).to eq(1)
        expect(SPARC::Protocol.count).to eq(1)
        expect(page).to have_content(SPARC::Protocol.first.identifier.truncate(60))
      end
    end
  end
end

def start_new_request
  visit sparc_requests_path

  click_button I18n.t(:requests)[:create]
  click_button I18n.t(:requests)[:create_confirm][:confirm]
  wait_for_ajax
end

def fill_in_line_item(service)
  bootstrap_select '#sparc_request_line_items_attributes_0_service_id', service.name
  bootstrap_select '#sparc_request_line_items_attributes_0_service_source'
  bootstrap_select '#sparc_request_line_items_attributes_0_query_name'
  fill_in 'sparc_request_line_items_attributes_0_number_of_specimens_requested', with: 5
  fill_in 'sparc_request_line_items_attributes_0_minimum_sample_size', with: '1mL'
end
