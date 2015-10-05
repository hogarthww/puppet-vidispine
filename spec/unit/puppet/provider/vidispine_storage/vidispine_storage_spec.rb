require 'spec_helper'

provider_class = Puppet::Type.type(:vidispine_storage).provider(:vidispine_storage)

describe provider_class do
  
  let(:name) { 'rspec vidispine_storage test' }
  
  let(:resource) { Puppet::Type.type(:vidispine_storage).new(
      :name       => 'storage1',
      :vshostname => 'localhost',
      :vsport     => '8080',
      :vsuser     => 'admin',
      :vspass     => 'admin',
      :provider   => :vidispine_storage,
    )}


  let(:resource_absent) { Puppet::Type.type(:vidispine_storage).new(
      :name       => 'storage1',
      :vshostname => 'localhost',
      :vsport     => '8080',
      :vsuser     => 'admin',
      :vspass     => 'admin',
      :provider   => :vidispine_storage,
      :ensure     => :absent
    )}

  let(:resource_scan) { Puppet::Type.type(:vidispine_storage).new(
      :name          => 'storage1',
      :vshostname    => 'localhost',
      :vsport        => '8080',
      :vsuser        => 'admin',
      :vspass        => 'admin',
      :provider      => :vidispine_storage,
      :scan_interval => 120,
    )}

  let(:provider) { resource.provider }
  let(:provider_absent) { resource_absent.provider }
  let(:provider_scan) { resource_scan.provider }

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

    it 'should correctly identify Storages with incorret metadata' do
      VCR.use_cassette('vidispine_storage-exists-incorrect-metadata') do
        expect(provider.exists?).to be_falsy
      end
    end

    it 'should correctly find existing Storages when ensure absent' do
      VCR.use_cassette('vidispine_storage-exists-true') do
        expect(provider_absent.exists?).to be_truthy
      end
    end

    it 'should correctly identify Storages with different metadata when ensure absent' do
      VCR.use_cassette('vidispine_storage-exists-incorrect-metadata') do
        expect(provider_absent.exists?).to be_truthy
      end
    end
  end

  describe 'create' do
    it 'should POST a StorageDocument to create the Storage' do
      VCR.use_cassette('vidispine_storage-create') do
        expect(provider.create).to be_truthy
      end
    end

    it 'should POST a StorageDocument to create the Storage with set ScanInterval' do
      VCR.use_cassette('vidispine_storage-create-scan') do
        expect(provider_scan.create).to be_truthy
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

  describe 'update' do
    it 'should PUT a StorageDocument to update the Storage' do
      VCR.use_cassette('vidispine_storage-update') do
        expect(provider.create).to be_truthy
      end
    end
  end
end

