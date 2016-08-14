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

  def add_parent_tag_to_product(product) # add tag to collection so that it knows it's parent
    if(product.tags.empty?)
      product.tags += title
      sleep(0.10)
      product.save
    elsif(!product.tags.include? title) 
      product.tags += ", #{title}"
      sleep(0.10)
      product.save
    end
    product
  end

  def get_collects(id)
    ShopifyAPI::Collect.all(:params => {:limit => 250,  :collection_id => id.to_s })
  end

  def map_products_from_collects(collects)
    collects.map do |collect| 
      sleep(0.25) # rate limiter maybe do less
      product = ShopifyAPI::Product.find(collect.attributes[:product_id])
      # get each product and check to make sure that it has a collection tag 
      add_parent_tag_to_product(product) 
    end 
  end

  def filter_variant_data(products, value)
    data = []
    products.each do |product| #anything with a slash should be split into two variables
      product.variants.each do |variant|
        #incase of nil
        var = variant.attributes[value] || "" 
        # push the formated color data into the data array
        data.push(format_color(var)) 
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

  # def has_tags?(products)
  #   products.each do |product|
  #     # if this isnt the first tag and it's not the same
  #     if(product.tags.empty?)
  #       product.tags += title
  #      # this is the first tag
  #     elsif(!product.tags.include? title) 
  #       product.tags += ", #{title}"
  #       product.save
  #       #need tags to save TODO
  #     end
  #   end
  #   products
  # end
