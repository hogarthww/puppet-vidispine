require 'spec_helper'

provider_class = Puppet::Type.type(:vidispine_thumbnails).provider(:vidispine_thumbnails)

describe provider_class do

  let(:name) { 'rspec vidispine_thumbnails test' }

  let(:resource) { Puppet::Type.type(:vidispine_thumbnails).new(
      :path       => 'file:///opt/vidispine/thumbnails/',
      :vshostname => 'localhost',
      :vsport     => '8080',
      :vsuser     => 'admin',
      :vspass     => 'admin'
      )}

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it "should be an instance of Puppet::Type::Vidispine_thumbnails::ProviderVidispine_thumbnails" do
    expect(provider).to be_an_instance_of Puppet::Type::Vidispine_thumbnails::ProviderVidispine_thumbnails
  end

  describe 'exists?' do
    it 'should correctly report non-existent thumbnail resources' do
      VCR.use_cassette('vidispine_thumbnails-exists-false') do
        expect(provider.exists?).to be_falsy
      end
    end

    it 'should correctly find existing thumbnail resources' do
      VCR.use_cassette('vidispine_thumbnails-exists-true') do
        expect(provider.exists?).to be_truthy
      end
    end
  end

  describe 'create' do
    it 'should create a thumbnail resource' do
      VCR.use_cassette('vidispine_thumbnails-create') do
        expect(provider.create).to be_truthy
      end
    end
  end

  describe 'destroy' do
    it 'should delete a thumbnail resource' do
      VCR.use_cassette('vidispine_thumbnails-destroy') do
        expect(provider.destroy).to be_truthy
      end
    end
  end

end

