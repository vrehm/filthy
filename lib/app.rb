require 'sinatra'
require 'shopify_api'
require_relative('collecion_data')
require_relative('filter')
require_relative('secrets')

#connect to the api
before do
  ShopifyAPI::Base.site = "https://#{API_KEY}:#{PASSWORD}@david-meister-sandbox.myshopify.com/admin"
end

helpers do

  # no idea if any of this works yet
  def get_data(collection)
    CollectionData.new(collection.title, collection.id)
  end

  def new_filter(first, collection_data, second)
    filter = Filter.new(collection_data.collection_title.to_s + '-' + first.to_s)
    filter.add_rules(first)
    # if this is the double filter
    if(second) 
      filter.add_rules(second) && filter.title += "-#{second.to_s}" 
    end
    filter.save && filter.add_meta
  end

  def create_filters(collection_data)
    collection_data.colors.each do |color|
       new_filter(color, collection_data)
       collection_data.sizes.each do |size| 
        new_filter(color, collection_data) && new_filter(size, color, collection_data) 
      end
    end
  end
end

# Homepage (Root path)
get '/' do
  @collections = ShopifyAPI::CustomCollection.all

  erb :index
end

post '/create-filter' do
  #it takes params 

  #creates new collection data

end
