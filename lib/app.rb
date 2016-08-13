require 'sinatra'
require "sinatra/json"
require 'shopify_api'
require 'rack/throttle'
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


  # def new_filter(first, collection_data, second)
  #   filter = Filter.new(collection_data.collection_title.to_s + '-' + first.to_s)
  #   filter.add_rules(first)
  #   # if this is the double filter
  #   if(second) 
  #     filter.add_rules(second) && filter.title += "-#{second.to_s}" 
  #   end
  #   filter.save && filter.add_meta
  # end

  # def create_filters(collection_data)
  #   collection_data.colors.each do |color|
  #      new_filter(color, collection_data)
  #      collection_data.sizes.each do |size| 
  #       new_filter(color, collection_data) && new_filter(size, color, collection_data) 
  #     end
  #   end
  # end
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


# post '/create-filter' do
#   #it takes params 

#   #creates new collection data

# end
