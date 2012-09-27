require 'sinatra/base'
require 'iated/mcp'
require 'iated/page_helpers'
require 'json'

## The various URLs
#pages_dir = File.expand_path '../pages', __FILE__
#Dir["#{pages_dir}/*.rb"].each do |path|
#require path.to_s
#end

module Iated
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
      values = {
        :tid  => params['tid'] ? params['tid'] : '',
        :url  => params['url'],
        :extension => params['extension'] ? params['extension'] : '.txt',
      }
      values[:text] = params['text'] if params['text']

      session = Iated::EditSession.new values
      session.edit
      content_type "text/json"
      return {:sid => session.sid}.to_json
    end

    get '/edit/:sid/:change_id' do |sid, change_id|
      change_id = change_id.to_i
      session = Iated::sessions[sid]
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
      if Iated::mcp.showing_secret?
        content_type "text/plain"
        response.status = 409
        return "busy"
      else
        Iated::mcp.show_secret
        content_type "text/json"
        return {:status => "ok"}.to_json
      end
    end

    post '/hello' do
      if Iated::mcp.confirm_secret params["secret"]
        content_type "text/json"
        token = Iated::mcp.generate_token env['HTTP_USER_AGENT']
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
      locals = {}
      SysPref::preference_names.each do |name|
        locals[name] = Iated.mcp.prefs.send(name)
      end
      params.keys.each do |key|
        locals[key] = params[key]
      end
      haml :preferences, :locals => locals
    end

    ## Handle changes.
    post '/preferences' do
      requires_token

      SysPref::preference_names.each do |name|
        if params.key? name.to_s
          Iated.mcp.prefs.send("#{name}=", params[name])
        end
      end

      redirect to("/preferences?token=#{params[:token]}")
    end
    get '/reference' do
      redirect to('/reference/'), 301
    end

    get '/reference/?' do
      last_modified(Time.now)
      haml :reference
    end

    get '/reference/script.js' do
      content_type "text/javascript", :charset => 'utf-8'
      last_modified(Time.now)
      coffee :reference
    end

    get '/reference/style.css' do
      content_type "text/css", :charset => 'utf-8'
      last_modified(Time.now)
      scss :reference
    end

    get '/' do
      haml :root
    end

    not_found do
      content_type "text/plain"
      last_modified Time.now.httpdate
      "Iated doesn't respond to that."
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
