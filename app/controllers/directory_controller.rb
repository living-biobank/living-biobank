class DirectoryController < ApplicationController
  def search
    results = Directory.search_ldap(params[:term]) || []
    results.map!{|y| [y.givenname, y.sn].join(' ')}
    render json: { results: results }
  end
end
