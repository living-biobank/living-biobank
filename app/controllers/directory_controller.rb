class DirectoryController < ApplicationController
  def search
    results = Directory.search_ldap(params[:term]) || []

    render json: { results: results.map { |y| {
      name: [y.givenname, y.sn].join(' '),
      email: y[:mail].first
    } } }
  end
end
