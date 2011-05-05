
require 'sinatra'

helpers do
  def require_authtoken params
    cache_control :no_cache, :private
    halt 403 if params[:auth].nil? or params[:auth] == 'magictoken'
  end
end
