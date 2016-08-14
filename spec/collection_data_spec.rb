require('collection_data')
require('./secrets')
#this was written TDD

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


  describe '#add_parent_tag_to_product' do

    before do
      @collection = CollectionData.new(1000, 'Summer-2016')
      @collection2 = CollectionData.new(1111, 'Spring-2016') 
      @products = [ShopifyAPI::Product.new(:tags => '', :title => 'dress'), ShopifyAPI::Product.new(:tags => 'Summer-2016', :title => 'dress')] 
    end

    it 'expect products argument to contain a product' do
      expect((@products)[0]).to be_a(ShopifyAPI::Product)
    end

    it 'product array responds to tags' do
      expect(@products[0]).to respond_to(:tags)
    end
    
    it 's first product tag is empty' do
      expect(@products[0].tags).to eq("")
    end

    it 'adds tags to the product if the product has none' do
      expect{@collection.add_parent_tag_to_product(@products[0])}.to change{@products[0].tags}.from("").to('Summer-2016')
    end

    it 'should return a product' do
      expect(@collection.add_parent_tag_to_product(@products[0])).to be_kind_of(ShopifyAPI::Product)
    end

    it 'should not add tags if the product allready has the same tag' do 
      expect(@collection.add_parent_tag_to_product(@products[1]).tags).to eq("Summer-2016") 
    end

    it 'should add other collection names to product tags' do 
      expect(@collection2.add_parent_tag_to_product(@products[1]).tags).to be == "Summer-2016, Spring-2016"
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

    it 'a collect should belong to the right collection id' do  ## TODO REMOVE DEPENDANCE ON API HERE
      expect(@collection.get_collects(@collection.id)[0].collection_id).to eq(268585345)  ## TODO REMOVE DEPENDANCE ON API HERE
    end

  end


  describe '#map_products_from_collects' do

    before(:all) do
      @collection = CollectionData.new(268585345, 'Summer-2016') 
      @subject = @collection.map_products_from_collects(@collection.get_collects(268585345))  ## TODO REMOVE DEPENDANCE ON API HERE
      @product_count = ShopifyAPI::CustomCollection.find(268585345).attributes[:products_count]  ## TODO REMOVE DEPENDANCE ON API HERE
    end

    it 'takes collects and returns an array' do
      expect(@subject).to be_an(Array)
    end 

    it 'returns products' do
      expect(@subject[0]).to be_kind_of(ShopifyAPI::Product)
    end

    it "should have all the products" do
      expect(@product_count).to eq(@subject.length)
    end

    after(:all) do
      sleep(1)
      puts 'sleeping please wait one second'
    end

  end


  describe '#filter_variant_data' do

    before(:all) do
      @products = [ ]
      @colors = [ 'Black', 'Pink', 'Pink/Red', 'Pink/Black', 'Pink / Red', 'Pink / Black', 'Blue', nil ]
      @colors.each do |color|
        product = ShopifyAPI::Product.new(:variants => [{:title => "2 / #{color}", :option1 => "2", :option2 => "#{color}" }])
        @products << product
      end

    end

    let(:subject) do
      @collection = CollectionData.new(268585345, 'Summer-2016') 
    end

    it 'expects products to have a length of 8' do
      expect(@products.length).to eql(8)
    end

    it 'should take products and return an array' do
      expect(subject.filter_variant_data(@products, :option2)).to be_kind_of(Array)
    end

    it 'should return an array of colors when passed an array of products' do
      expect(subject.filter_variant_data(@products, :option2)).to include('Black', 'Pink', 'Blue')
    end

    it 'should not have any slashes in the names' do
      expect(subject.filter_variant_data(@products, :option2)).to match_array(['Black', 'Pink', 'Red', 'Blue'])
    end

    it 'can not include a nil in an array' do
      expect(subject.filter_variant_data(@products, :option2)).not_to include([nil])
    end

    it 'can not contain nil' do
      expect(subject.filter_variant_data(@products, :option2)).not_to include(nil)
    end

    it 'should return an array of sizes if passed option1' do
      expect(subject.filter_variant_data(@products, :option1)).to include("2")
    end

  end


  describe '#format_array' do

    let(:subject) do
      @collection = CollectionData.new(268585345, 'Summer-2016') 
    end

    it 'takes an array of colors and removes unwated elements' do
      array = [ 'Black', 'Pink', 'Pink', 'Pink', 'Blue', nil, nil, nil ]
      expect(subject.format_array(array)).to match_array(['Black', 'Pink', 'Blue'])
    end
  end

()
  describe '#format_color' do

    let(:subject) do
      @collection = CollectionData.new(268585345, 'Summer-2016') 
    end

    it 'removes / from string an returns array of strings' do
      expect(subject.format_color('Black / Blue')).to match_array(['Black', 'Blue'])
    end

    it 'checks to see that the sting includes a slash if not it returns the string unharmed' do
      expect(subject.format_color('Black')).to eq('Black')
    end

    it 'removes any white space from single color' do
      expect(subject.format_color('Black ')).to eq('Black')
    end
    
  end

end