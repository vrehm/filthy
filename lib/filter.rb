require 'shopify_api'

class Filter # this has not been tested
  
  attr_accessor :title, :rules

  def initialize()
    @title = ''
    @rules = [{:column => 'variant_inventory', :relation => 'greater_than', :condition => '0'}]
    @meta = []
  end

  def save
    filter = ShopifyAPI::SmartCollection.new
    filter.attributes[:rules] = @rules
    filter.attributes[:title] = @title
    if(filter.save())
      puts 'save succesful'
      puts 'saving meta'
      filter.add_metafield(@meta)
      puts 'meta is saved'
      sleep(0.50)
    else
      puts 'not saved'
    end
  end

  def add_rules(column, relation, arg) 
    @rules << {:column => column, :relation => relation, :condition => arg.to_s }
  end

  def add_meta(key, value, value_type, namespace)
    @meta = ShopifyAPI::Metafield.new
    @meta.attributes[:key] = key
    @meta.attributes[:value] = value
    @meta.attributes[:value_type] = value_type
    @meta.attributes[:namespace] = namespace
  end


end