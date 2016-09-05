require 'shopify_api'


class CollectionData

  attr_reader :id, :title, :products
  attr_accessor :sizes, :colors, :collects

  def initialize(id, title)
    @id       = id
    @title    = title
    @collects = []
    @products = []
    @colors   = []
    @sizes    = []
  end

  def set_colors
    @colors = filter_variant_data(products, :option2)
  end

  def set_products(products, collects)
    @products = map_products_from_collects(collects, products).flatten
  end

  def map_products_from_collects(collects, products)
    collects.map do |collect| 
      products.select do |product| 
        product.attributes[:id] == collect.attributes[:product_id] 
      end
    end 
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


