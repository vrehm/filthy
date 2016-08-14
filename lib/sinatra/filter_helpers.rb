require 'sinatra/base'

module Sinatra
  module FilterHelper
    # # no idea if any of this works yet
    def get_data(title, id)
      collection = CollectionData.new(id, title)
      collection.set_products
      collection.set_colors
      collection.sizes = [2,4,6,8,10,12,14]
      return collection
    end
    
  end

  helpers FilterHelper
end