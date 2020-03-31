class ControlPanel::BaseController < ApplicationController
  layout 'control_panel'

  before_action :verify_admin
end
