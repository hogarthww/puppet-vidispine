require 'spec_helper'

provider_class = Puppet::Type.type(:vidispine_storage_method).provider(:vidispine_storage_method)

describe provider_class do
  
  let(:name) { 'rspec vidispine_storage_method test' }
  
  let(:resource) { Puppet::Type.type(:vidispine_storage_method).new(
      :name       => 'file:///opt/vidispine/storage2/',
      :storageuri => 'file:///opt/vidispine/storage2/',
      :vsurl      => 'http://localhost:8080',
      :vsuser     => 'admin',
      :vspass     => 'admin',
      :location   => 'storage2',
      :read       => 'true',
      :write      => 'true',
      :browse     => 'true',
    )}

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it "should be an instance of Puppet::Type::Vidispine_storage::ProviderVidispine_storage_method" do
    expect(provider).to be_an_instance_of Puppet::Type::Vidispine_storage_method::ProviderVidispine_storage_method
  end

  describe 'exists?' do
    it 'should correctly report non-existent storage methods' do
      VCR.use_cassette('vidispine_storage_method-exists-false') do
        expect(provider.exists?).to be_falsy
      end
    end

    it 'should correctly report non-existence of storage methods with non-existent parent storages' do
      VCR.use_cassette('vidispine_storage_method-no-parent-exists-false') do
        expect(provider.exists?).to be_falsy
      end
    end

    it 'should correctly find existing storage methods' do
      VCR.use_cassette('vidispine_storage_method-exists-true') do
        expect(provider.exists?).to be_truthy
      end
    end
  end

  describe 'create' do
    it 'should create a storage method' do
      VCR.use_cassette('vidispine_storage_method-create') do
        expect(provider.create).to be_truthy
      end
    end
  end

  describe 'destroy' do
    it 'should delete a storage method' do
      VCR.use_cassette('vidispine_storage_method-destroy') do
        expect(provider.destroy).to be_truthy
      end
    end
  end

end

