require './secrets'

require './lib/collection_data'
require './lib/filter'
require './lib/sinatra/filter_helpers'
require './lib/sinatra/asset_pipeline'
# shopify
require 'shopify_api'
# sinatra stuff + sprockets
require 'sinatra'
require 'sinatra/base'
require "sinatra/json"



#connect to the api
class Filthy < Sinatra::Base
  register AssetPipeline::Assets
  helpers Sinatra::FilterHelper

  before do
    ShopifyAPI::Base.site = "https://#{API_KEY}:#{PASSWORD}#{URL}"
    @all_products = get_all_products()
  end

  get '/' do
    erb :index
  end

  get '/custom-collections/:name' do
    name = params['name']
    name.slice!(0)
    # find the collection with the paramters of the name in url, since it's an array access it's attributes
    @collection = ShopifyAPI::CustomCollection.find(:all, :params => {"handle"=>name})[0].attributes
    # use the get_collection_data helper to create a collection object and then return it to the view in json
    @collection_data = get_collection_data(@collection[:title], @collection[:id], @all_products)  
    json :collection_data => @collection_data
  end

  get '/smart-collections/:id' do #TODO make sure this works :)
    id = params['id']
    id.slice!(0)
    @collection = ShopifyAPI::SmartCollection.find(id)
    @collection_data = get_collection_data(@collection.title, @collection.id, @all_products)  
    json :collection_data => @collection_data
  end

  post '/create-filter' do
    payload = params
    payload = JSON.parse(request.body.read).symbolize_keys unless params[:path]

    puts "I got some JSON: #{payload.inspect}"

    #TODO Take in collection data and parse it's colors and sizes

    # Return collection with meta fields for size and colors associated with it's filters 
    # It should also have a meta tags stating that it's been cleaned by filthy
  end
 
  #Make post route for creating collection

  #Make get route for clean collectionsnb
end
