class SparcRequestsController < ApplicationController

  def new
    @sparc_request = SparcRequest.new
  end
end
