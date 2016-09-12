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

  #Make post route for creating collection

  #Make get route for clean collectionsnb
end
