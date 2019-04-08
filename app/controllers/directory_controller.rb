class DirectoryController < ApplicationController
  def search
    results = Directory.search_ldap(params[:term]) || []

    render json: { results: results.map { |r| {
      display_name: [r[:givenname].first, r[:sn].first, '(', r[:mail].first, ')'].join(' '),
      name: [r[:givenname].first, r[:sn].first].join(' '),
      netid: r[:uid].first,
      email: r[:mail].first
    } } }
  end
end
