require 'shopify_api'
require_relative('collection_data')
require_relative('filter')
require_relative('secrets')

ShopifyAPI::Base.site = "https://#{API_KEY}:#{PASSWORD}#{URL}"

def new_filter(collection_data, args = [])
  filter = Filter.new

  title = collection_data.collection_title.to_s.chomp
  # add the title and the rules 
  filter.title = title+"-"+args[0].to_s.chomp
  filter.add_rules('variant_title', 'contains', args[0])
  filter.add_rules('tag', 'equals', title)
  
  # # if this is the double filter
  if(args.length > 1) 
    filter.add_rules('variant_title', 'contains', args[1])
    filter.title += "-".chomp+"#{args[1].to_s.chomp}" 
  end

  puts "adding: "+filter.title
  filter.save()
  # save the filter and label it's meta as a filter
end

def create_filters(collection_data)  
  
  collection_data.colors.each do |color|
     new_filter(collection_data, [color])
     sleep(0.75)
     collection_data.sizes.each do |size| 
      new_filter(collection_data, [color, size] ) 
      sleep(0.75)
    end
  end

  collection_data.sizes.each do |size|
    new_filter(collection_data, [size] ) 
    sleep(0.75)
  end
end


# this runs the machine! :)
def deleteFilters(filters)
  filters.each do |f| 
    filter = ShopifyAPI::SmartCollection.find(f.id)
    puts "delete: "+filter.title
    filter.destroy
    sleep(0.75)
  end
end

# delete all the filters first before running
puts "this could take a while..."

deleteFilters(ShopifyAPI::SmartCollection.find(:all, :params => {:limit => 250}))


@collections = ShopifyAPI::CustomCollection.all

@collections.each do |collection|
  create_filters(CollectionData.new(collection.id, collection.title))
end

