require 'shopify_api'
require './lib/collection_data'
require './lib/filter'
require './secrets'
# helper methods 
require './lib/sinatra/filter_helpers'
# sinatra stuff + sprockets
require 'sinatra'
require 'sinatra/base'
require "sinatra/json"

require 'sprockets'
require 'sass'



#connect to the api
class Filthy < Sinatra::Base
  helpers Sinatra::FilterHelper
    # initialize new sprockets environment
  set :environment, Sprockets::Environment.new

  # append assets paths
  environment.append_path "assets/stylesheets"
  environment.append_path "assets/javascripts"

  # compress assets
  environment.js_compressor  = :uglify
  environment.css_compressor = :scss

  before do
    ShopifyAPI::Base.site = "https://#{API_KEY}:#{PASSWORD}#{URL}"
  end

  get '/' do
    @collections = ShopifyAPI::CustomCollection.all
    erb :index
  end

  get '/collections/:id' do
    id = params['id']
    id.slice!(0)
    @collection = ShopifyAPI::CustomCollection.find(id)
    @collection_data = get_data(@collection.title, @collection.id)  
    json :collection_data => @collection_data
  end

  post '/collections/:id/filters/new' do
    id = params['id']
    # accept @collection_data
  end

end
