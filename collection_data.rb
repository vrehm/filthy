require 'shopify_api'

class CollectionData #this is the only sure thing right now

  attr_reader :products, :colors, :sizes, :collection_id
  attr_accessor :collection_title, :collection_id

  def initialize(id, title)
    @collection_title = title
    @collection_id = id
    @products = find_products(get_collects(collection_id))
    @colors = get_options(products, :option2).flatten.uniq.compact
    @sizes = get_options(products, :option1).flatten.uniq.compact
  end

  def get_collects(id)
    ShopifyAPI::Collect.all(:params => { :collection_id => id.to_s } )
  end
 

 ## TODO FIX PRODUCT TAG ISSUE BECAUSE THIS ISN'T WORKING
  def find_products(collects)
    collects.map do |collect| 
      product = ShopifyAPI::Product.find(collect.attributes[:product_id])
      if(!product.tags.include? collection_title.to_s.chomp)
        product.tags += ", #{collection_title}".to_s.chomp
        if(product.save)
          puts 'product saved'
        else
          puts 'product not saved'
        end
      end
      product
    end 
  end

  def get_options(array, option)
    array.map do |p| 
      p.variants.map { |v| !v.attributes[option].nil? ? v.attributes[option].split('/')[0].chomp.rstrip : nil }
    end
  end
end

