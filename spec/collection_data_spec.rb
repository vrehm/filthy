require('collection_data')
require('./secrets')

describe 'CollectionData' do

  before do 
    # connect to shopify
    ShopifyAPI::Base.site = "https://#{API_KEY}:#{PASSWORD}#{URL}"
  end

  describe 'shopify connection' do
    it 'can create a new product' do
      expect(ShopifyAPI::Product.new).to be_a(ShopifyAPI::Product)        
    end
  end

  describe 'attributes' do

    before do
      @collection = CollectionData.new(10000, 'Summer-2016')
    end

    it 'has an array for its products' do
      expect(@collection.products).to be_kind_of(Array)
    end

    it 'has a collection id' do
      expect(@collection.id).to eq(10000)
    end

    it 'has a title' do
      expect(@collection.title).to eq('Summer-2016')
    end

  end

  describe '#has_tags?' do

    before do
      @collection = CollectionData.new(1000, 'Summer-2016')
      @collection2 = CollectionData.new(1111, 'Spring-2016')
      @products = [ShopifyAPI::Product.find(7156459905)]
      @products[0].tags = ""
    end

    it 'takes and array of products and returns an array of products' do
      expect((@products)[0]).to be_a(ShopifyAPI::Product)
    end
    
    it 'expects product tags to be empty' do
      expect(@products[0].tags).to eq("")
    end

    it 'adds tags to the product if the product has none' do
      expect{@collection.has_tags?(@products)}.to change{@products[0].tags}.from("").to('Summer-2016')
    end

    it 'should return an array' do
      expect(@collection.has_tags?(@products)).to be_kind_of(Array)
    end

    it 'should not add tags if the product allready has the same tag' do 
      @collection.has_tags?(@products)
      expect(@collection.has_tags?(@products)[0].tags).to eq("Summer-2016") 
    end

    it 'should add other collection name to product tag' do
      @collection.has_tags?(@products) 
      expect(@collection2.has_tags?(@products)[0].tags).to be == "Summer-2016, Spring-2016"
    end

  end


  describe '#get_collects' do

    before do
      @collection = CollectionData.new(268585345, 'Summer-2016')
      sleep(0.1)
    end

    it 'should take a product collection id and return an array' do
      expect(@collection.get_collects(@collection.id)).to be_an(ActiveResource::Collection)
    end

    it 'should return an array of ShopifyAPI::Collect' do
      expect(@collection.get_collects(@collection.id)[0]).to be_a(ShopifyAPI::Collect)
    end

    it 'a collect should belong to the right collection id' do
      expect(@collection.get_collects(@collection.id)[0].collection_id).to eq(268585345)
    end

  end


  describe '#map_products_from_collects' do

    let(:collection) { CollectionData.new(268585345, 'Summer-2016') }      
    let(:subject) { collection.map_products_from_collects(collection.get_collects(268585345)) }

    before do
      @product_count = ShopifyAPI::CustomCollection.find(268585345).attributes[:products_count]
      sleep(0.1)
    end

    it 'takes collects and returns an array' do
      expect(subject).to be_an(Array)
    end 

    it 'returns products' do
      expect(subject[0]).to be_kind_of(ShopifyAPI::Product)
    end

    it "should have all the products" do
      expect(@product_count).to eq(subject.length)
    end

    after do
      sleep(0.50)
    end

  end



  # describe '#map_products' do
    
  #   it 'return an array of ShoppifyProducts that belong to the collection' do
        
  #   end

  # end 



  # describe '#get_colors' do

  #   before do
  #     # create a product with variants
  #   end

  #   it 'returns an array of color names'
  #     #expect colors to eq
  #   end

  # end
  
  # describe "#add_tags_to_product" do
    
  #   it 'returns a product with tags' do

  #   end
  
  # end

  # describe "#get_options" do
    
  #   it 'takes an array of products' do

  #   end

  #   it 'returns an array of string names' do

  #   end

  #   it 'it should split the string into two' do

  #   end

  # end

end