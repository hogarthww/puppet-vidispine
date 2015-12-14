require 'spec_helper'

provider_class = Puppet::Type.type(:vidispine_transcoder).provider(:vidispine_transcoder)

describe provider_class do

  let(:name) { 'rspec vidispine_transcoder test' }

  let(:resource) { Puppet::Type.type(:vidispine_transcoder).new(
      :name     => 'rspec',
      :url      => 'http://transcoder.zonza.mock:8888/',
      :ensure   => 'present',
      :vsurl    => 'http://localhost:8080',
      :vsuser   => 'admin',
      :vspass   => 'admin',
      :provider => :vidispine_transcoder
    ) }
  
  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it "should be an instance of Puppet::Type::Vidispine_transcoder::ProviderVidispine_transcoder" do
    expect(provider).to be_an_instance_of Puppet::Type::Vidispine_transcoder::ProviderVidispine_transcoder
  end

  describe 'exists?' do
    it 'should correctly report non-existent transcoders' do
      VCR.use_cassette('vidispine_transcoder-exists-false') do
        expect(provider.exists?).to be_falsy
      end
    end
    
    it 'should correctly find existing transcoders' do
      VCR.use_cassette('vidispine_transcoder-exists-true') do
        expect(provider.exists?).to be_truthy
      end
    end
  end

  describe 'create' do
    it 'should POST an XML document to create the transcoder' do
      VCR.use_cassette('vidispine_transcoder-create') do
        expect(provider.create).to be_truthy
      end
    end
  end

  describe 'destroy' do
    it 'should DELETE the transcoder VX-ID' do
      VCR.use_cassette('vidispine_transcoder-destroy') do
        expect(provider.destroy).to be_truthy
      end
    end
  end

end
