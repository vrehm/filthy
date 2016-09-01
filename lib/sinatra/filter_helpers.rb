require 'sinatra/base'

module Sinatra
  module FilterHelper
    # # no idea if any of this works yet
    def get_collection_data(title, id, all_products, all_collects)
      collection = CollectionData.new(id, title)
      collection.set_collects(all_collects, id)
      collection.set_products(all_products, collection.collects)
      collection.set_colors
      collection.sizes = [2,4,6,8,10,12,14]
      return collection
    end

    def get_all_products()
      product_count = ShopifyAPI::Product.count
      nb_pages      = (product_count / 250.0).ceil
      products      = []
      minimum       = 1

      1.upto(nb_pages) do |page|
        load = ShopifyAPI::Product.find( :all, :params => { :limit => 250, :page => page })
        products.push(load)
        sleep(0.50)
      end
      return products.flatten
    end

    def get_all_collects()
      collect_count = ShopifyAPI::Collect.count
      nb_pages      = (collect_count / 250.0).ceil
      collects      = []
      minimum       = 1 

      1.upto(nb_pages) do |page|
        load = ShopifyAPI::Collect.find( :all, :params => { :limit => 250, :page => page })
        collects.push(load)
        sleep(0.50)
      end
      return collects.flatten
    end

  end

  helpers FilterHelper
end