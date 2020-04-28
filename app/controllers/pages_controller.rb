class PagesController < ApplicationController
  respond_to :html

  skip_before_action :authenticate_user!, only: :user_guide

  def help
  end

  def user_guide
    render layout: 'home'
  end
end
