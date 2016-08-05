require 'shopify_api'

class Filter # this has not been tested
  
  attr_accessor :title, :rules

  def initialize()
    @title = ''
    @rules = [{:column => 'variant_inventory', :relation => 'greater_than', :condition => '0'}]
  end

  def add_meta
    this.add_meta({:key => "role", :value => "filter", :value_type => "string", :namespace => "global"})
  end

  def save
    filter = ShopifyAPI::SmartCollection.new
    filter.attributes[:rules] = @rules
    filter.attributes[:title] = @title
    if(filter.save())
      puts 'save succesful'
    else
      puts 'not saved'
    end
  end

  def add_rules(column, relation, arg) 
    @rules << {:column => column, :relation => relation, :condition => arg.to_s }
  end

end