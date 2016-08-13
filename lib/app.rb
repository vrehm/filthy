require 'sinatra'
require "sinatra/json"
require 'shopify_api'
require('./lib/collection_data')
require('./lib/filter')
require ('./secrets')

#connect to the api
before do
  ShopifyAPI::Base.site = "https://#{API_KEY}:#{PASSWORD}#{URL}"
end

helpers do
  # # no idea if any of this works yet
  def get_data(title, id)
    collection = CollectionData.new(id, title)
    collection.set_products
    collection.set_colors
    return collection
  end

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
