require 'spec_helper'

provider_class = Puppet::Type.type(:transcoder_address).provider(:transcoder_address)

describe provider_class do

  let(:name) { 'rspec transcoder_address test' }

  let(:resource) { Puppet::Type.type(:transcoder_address).new(
      :name       => 'http://transcoder.zonza.mock:8888/',
      :ensure     => 'present',
      :vshostname => 'localhost',
      :vsport     => '8080',
      :vsuser     => 'admin',
      :vspass     => 'admin',
      :provider   => :transcoder_address
    ) }
  
  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it "should be an instance of Puppet::Type::Transcoder_address::ProviderTranscoder_address" do
    expect(provider).to be_an_instance_of Puppet::Type::Transcoder_address::ProviderTranscoder_address
  end

  describe 'exists?' do
    it 'should correctly report non-existent transcoders' do
      VCR.use_cassette('transcoder_address-exists-false') do
        expect(provider.exists?).to be_falsy
      end
    end
    
    it 'should correctly find existing transcoders' do
      VCR.use_cassette('transcoder_address-exists-true') do
        expect(provider.exists?).to be_truthy
      end
    end
  end

  describe 'create' do
    it 'should POST an XML document to create the transcoder' do
      VCR.use_cassette('transcoder_address-create') do
        expect(provider.create).to be_truthy
      end
    end
  end

  describe 'destroy' do
    it 'should DELETE the transcoder VX-ID' do
      VCR.use_cassette('transcoder_address-destroy') do
        expect(provider.destroy).to be_truthy
      end
    end
  end

end
