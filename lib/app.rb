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

    @all_products = get_all_products();
    @all_collects = get_all_collects();

  end

  get '/' do
    @collections = ShopifyAPI::CustomCollection.all
    ## TODO get all products
    erb :index
  end

  get '/collections/:id' do
    id = params['id']
    id.slice!(0)
    @collection = ShopifyAPI::CustomCollection.find(id)
    @collection_data = get_collection_data(@collection.title, @collection.id, @all_products, @all_collects)  
    json :collection_data => @collection_data
  end

  post '/collections/:id/filters/new' do
    id = params['id']
    # accept @collection_data
  end

end
