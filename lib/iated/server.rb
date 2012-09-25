require 'sinatra/base'
require 'iated/mcp'
require 'iated/page_helpers'
require 'json'

## The various URLs
#pages_dir = File.expand_path '../pages', __FILE__
#Dir["#{pages_dir}/*.rb"].each do |path|
#require path.to_s
#end

module IATED
  class Server < Sinatra::Base
    # Server HAML as HTML5
    set :haml, :format => :html5

    helpers do
      def request_headers
        env.inject({}){|acc, (k,v)| acc[$1.downcase] = v if k =~ /^http_(.*)/i; acc}
      end
    end

    post '/edit' do
      requires_token
      halt 400 unless params['url']
      halt 400 unless params['text']
      values = {
        :tid  => params['tid'] ? params['tid'] : '',
        :text => params['text'],
        :url  => params['url'],
        :extension => params['extension'] ? params['extension'] : '.txt',
      }
      session = IATed::EditSession.new values
      session.edit
      content_type "text/json"
      return {:sid => session.sid}.to_json
    end

    get '/edit/:sid/:change_id' do |sid, change_id|
      change_id = change_id.to_i
      session = IATed::sessions[sid]
      if session.nil?
        halt 404
      else
        content_type "text/json"
        resp = {
          :change_id => session.change_id,
        }
        if session.change_id > change_id
          resp[:text] = session.text
        end
        return resp.to_json
      end
    end

    get '/hello/?' do
      last_modified Time.now.httpdate
      if IATed::mcp.showing_secret?
        content_type "text/plain"
        response.status = 409
        return "busy"
      else
        IATed::mcp.show_secret
        content_type "text/json"
        return {:status => "ok"}.to_json
      end
    end

    post '/hello' do
      if IATed::mcp.confirm_secret params["secret"]
        content_type "text/json"
        token = IATed::mcp.generate_token env['HTTP_USER_AGENT']
        return {:token => token}.to_json
      else
        halt 403
      end
    end

    get '/ping' do
      content_type "text/plain"
      last_modified Time.now.httpdate
      "pong"
    end

    post '/ping' do
      requires_token
      content_type "text/plain"
      last_modified Time.now.httpdate
      "pong"
    end

    get '/pong' do
      raise Exception, "Boom!"
    end

    ## Display the preferences web page.
    get '/preferences' do
      requires_token
      haml :preferences
    end

    ## Handle changes.
    post '/preferences' do
      # TODO require_authtoken params
      redirect to('/preferences')
    end

    get '/' do
      haml :root
    end

    not_found do
      content_type "text/plain"
      last_modified Time.now.httpdate
      "IATed doesn't respond to that."
    end

    error do
      "There was an error of some sort - #{env['sinatra.error']}"
    end

    # We can add custom errors here as well:
    #error MyCustomError do
    #  'So what happened was...' + env['sinatra.error'].message
    #end

  end
end
