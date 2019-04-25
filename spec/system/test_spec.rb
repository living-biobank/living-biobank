require 'rails_helper'

RSpec.describe 'User does something', js: true do
  login_user_for_each_test

  before :each do
    create(:sparc_request, :without_validations, line_item_count: 1)
  end

  it 'test' do
    visit root_path
  end  
end
