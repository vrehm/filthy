require 'shopify_api'

class CollectionData #this is the only sure thing right now

  attr_reader :products, :colors, :sizes
  attr_accessor :collection_title, :collection_id

  def initialize(id, title, sizes)
    @collection_title = title
    @collection_id = id
    @products = has_tags?(map_products(get_collects(collection_id))
    @colors = get_options(products, :option2).flatten.uniq.compact
    @sizes = sizes
  end


  def get_collects(id)
    ShopifyAPI::Collect.all(:params => { :collection_id => id.to_s })
  end
 
  def map_products_from_collection(collects)
    collects.map { |collect| add_tags_to_product(ShopifyAPI::Product.find(collect.attributes[:product_id]))} 
  end

  def get_options(array, option)
    array.map do |p| #if the attribue exists split it because bad things wont happen if it doesn't contain a /
      p.variants.map { |v| !v.attributes[option].nil? ? v.attributes[option].split('/')[0].chomp.rstrip : false }
    end
  end

  def has_tags?(products)
    products.each do |product|
      if(!product.tags.include? collection_title)
        product.tags += ", #{collection_title}"
        product.save
      end
    end
    return products
  end
end