require 'shopify_api'

class Filter

  attr_reader :meta
  attr_accessor :title, :rules

  def initialize()
    @title = ''
    @rules = [{:column => 'variant_inventory', :relation => 'greater_than', :condition => '0'}]
    @meta = ShopifyAPI::Metafield.new
  end

  def create #TODO create and savegit  split this up into two
    filter = ShopifyAPI::SmartCollection.new
    filter.attributes[:rules] = @rules
    filter.attributes[:title] = @title
    return filter
  end

  def add_rules(column, relation, arg) 
    @rules << {:column => column, :relation => relation, :condition => arg.to_s }
  end

  def add_meta(key, value, value_type, namespace)
    @meta.attributes[:key] = key
    @meta.attributes[:value] = value
    @meta.attributes[:value_type] = value_type
    @meta.attributes[:namespace] = namespace
  end
end