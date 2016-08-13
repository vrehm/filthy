require 'shopify_api'


class CollectionData

  attr_reader :id, :title, :colors, :products
  attr_accessor :sizes

  def initialize(id, title)
    @id = id
    @title = title
    @products = []
    @colors = []
    @sizes = []
  end

  def set_products
    @products = map_products_from_collects(get_collects(id))
  end

  def set_colors
    @colors = filter_variant_data(products, :option2)
  end

  def has_tags?(products)
    products.each do |product|
      # if this isnt the first tag and it's not the same
      if(product.tags.empty?)
        product.tags += title
       # this is the first tag
      elsif(!product.tags.include? title) 
        product.tags += ", #{title}"
      end
    end
    products
  end

  def get_collects(id)
    ShopifyAPI::Collect.all(:params => { :collection_id => id.to_s })
  end

  def map_products_from_collects(collects)
    collects.map do |collect| 
      # sleep(0.25) # rate limiter maybe do less
      ShopifyAPI::Product.find(collect.attributes[:product_id]) 
    end 
  end

  def filter_variant_data(products, value)
    data = []
    products.each do |product| #anything with a slash should be split into two variables
      product.variants.each do |variant|

        var = variant.attributes[value] || "" #incase of nil

        data.push(format_color(var)) # push the formated color data into the data array
      end
    end
    format_array(data).reject(&:empty?) # format data here to remove doubles, nil and flattens 
  end

  def format_array(array)
    return array.flatten.compact.uniq
  end

  def format_color(string)
    (string.include? '/') && !string.nil? ? string.split('/').map{ |x| x.strip } : string.strip
  end

end
