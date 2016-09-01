require('shopify_api')
require('./lib/collection_data')
require('./lib/filter')
require('./secrets')

ShopifyAPI::Base.site = "https://#{API_KEY}:#{PASSWORD}#{URL}"

def new_filter(collection_data, args = [])
  filter = Filter.new

  title = collection_data.title.to_s.chomp
  # add the title and the rules 
  filter.title = title+"-"+args[0].to_s.chomp
  filter.add_rules('variant_title', 'contains', args[0])
  filter.add_rules('tag', 'equals', title)
  filter.add_meta('parent', title.to_s, 'string', 'global')
  
  # # if this is the double filter
  if(args.length > 1) 
    filter.add_rules('variant_title', 'contains', args[1])
    filter.title += "-".chomp+"#{args[1].to_s.chomp}" 
  end

  puts "adding: "+filter.title
  save_filter(filter.create, filter.meta)
  # save the filter and label it's meta as a filter
end

def create_filters(collection_data, sizes)
  # initialize the data in the collections
  collection_data.set_products()
  sleep(0.50)
  collection_data.set_colors()
  sleep(0.50)
  collection_data.sizes = sizes
  # filter through the colors
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

def save_filter(filter, meta)
  if(filter.save())
    puts 'save succesful'
    puts 'saving meta'
    filter.add_metafield(meta)
    puts 'meta is saved'
    sleep(0.50)
  else
    puts 'not saved'
  end
end

# this runs the machine! :)
def delete_filters(filters)
  filters.each do |f| 
    filter = ShopifyAPI::SmartCollection.find(f.id)
    puts "delete: "+filter.title
    filter.destroy
    sleep(0.75)
  end
end

# delete all the filters first before running
puts "hold on to your butts..."
puts "This could take a while"

delete_filters(ShopifyAPI::SmartCollection.find(:all, :params => {:limit => 250}))


@collections = ShopifyAPI::CustomCollection.all

@collections.each do |collection|
  sizes = [2, 4, 6, 8, 10, 12, 14, 16]
  create_filters(CollectionData.new(collection.id, collection.title), sizes)
end

