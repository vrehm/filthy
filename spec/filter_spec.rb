require('filter')
require('./secrets')
# This was created after and is not derived from TDD

describe 'Filter' do

  before do 
    # connect to shopify
    ShopifyAPI::Base.site = "https://#{API_KEY}:#{PASSWORD}#{URL}"
  end
  
  describe 'attributes' do

    let(:subject) { Filter.new }

    it 'is a filter' do
      expect(subject).to be_kind_of(Filter)
    end

    it 'responds to title' do
      subject.title = 'title'
      expect(subject.title).to eql('title')
    end

    it 'responds to rules' do
      subject.rules = "rules"
      expect(subject.rules).to eq('rules')
    end

    it 'meta is a Metafield' do
      expect(subject.meta).to be_kind_of(ShopifyAPI::Metafield)
    end

    it 'me is read only' do

    end 

  end

  describe '#create' do

    let(:subject) { Filter.new }

    it 'returns a smart collection' do
      expect(subject.create).to be_kind_of(ShopifyAPI::SmartCollection)
    end

    it 'the new filter has title' do
      subject.title = 'filter'
      expect(subject.create).to respond_to(:title) 
    end

    it 'the new filter responds to rules' do
      expect(subject.create).to respond_to(:rules) 
    end

    it 'has the base rule quantity rule' do
      expect(subject.create.attributes[:rules]).to match_array([{:column => 'variant_inventory', :relation => 'greater_than', :condition => '0'}])
    end

  end

  describe '#add_rules' do

    let(:subject) {Filter.new}

    # it 'should have three arguments' do
    #   expect(subject.add_rules('one')).to raise
    # end

    it 'should add rules to rules' do
      expect {subject.add_rules('column', 'relation', 'arg')}.to change{subject.rules.length}.from(1).to(2)
    end

  end

  describe '#add_meta' do

    let(:subject) {Filter.new}

    before do
      subject.add_meta('key', 'value', 'value_type', 'namespace')
    end

    it 'should change key of @meta attirbue' do
      expect(subject.meta.attributes[:key]).to eql('key')
    end

    it 'should change value of @meta attirbue' do
      expect(subject.meta.attributes[:value]).to eql('value')
    end

    it 'should change value_type of @meta attirbue' do
      expect(subject.meta.attributes[:value_type]).to eql('value_type')
    end

    it 'should change the namespace of @meta attirbue' do
      expect(subject.meta.attributes[:namespace]).to eql('namespace')
    end

  end


end