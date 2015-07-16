require 'spec_helper'

provider_class = Puppet::Type.type(:vidispine_storage).provider(:vidispine_storage)

describe provider_class do
  
  let(:name) { 'rspec vidispine_storage test' }
  
  let(:resource) { Puppet::Type.type(:vidispine_storage).new(
      :name       => 'storage1',
      :vshostname => '192.168.20.24',
      :vsport     => '8080',
      :vsuser     => 'admin',
      :vspass     => 'admin',
      :provider   => :vidispine_storage,
    )}

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it "should be an instance of Puppet::Type::Vidispine_storage::ProviderVidispine_storage" do
    expect(provider).to be_an_instance_of Puppet::Type::Vidispine_storage::ProviderVidispine_storage
  end

  describe 'exists?' do
    it 'should correctly report non-existent Storages' do
      VCR.use_cassette('vidispine_storage-exists-false') do
        expect(provider.exists?).to be_falsy
      end
    end

    it 'should correctly find existing Storages' do
      VCR.use_cassette('vidispine_storage-exists-true') do
        expect(provider.exists?).to be_truthy
      end
    end
  end

  describe 'create' do
    it 'should POST a StorageDocument to create the Storage' do
      VCR.use_cassette('vidispine_storage-create') do
        expect(provider.create).to be_truthy
      end
    end
  end

  describe 'destroy' do
    it 'should DELETE the Storage ID to remove the Storage' do
      VCR.use_cassette('vidispine_storage-destroy') do
        expect(provider.destroy).to be_truthy
      end
    end
  end
end

