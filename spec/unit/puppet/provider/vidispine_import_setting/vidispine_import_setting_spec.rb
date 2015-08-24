require 'spec_helper'

provider_class = Puppet::Type.type(:vidispine_import_setting).provider(:vidispine_import_setting)

describe provider_class do
  
  let(:name) { 'rspec vidispine_import_setting test' }
  
  let(:resource) { Puppet::Type.type(:vidispine_import_setting).new(
      :permission => 'READ',
      :group      => 'rspec',
      :vshostname => 'localhost',
      :vsport     => '8080',
      :vsuser     => 'admin',
      :vspass     => 'admin'
    )}

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it "should be an instance of Puppet::Type::Vidispine_import_setting::ProviderVidispine_import_setting" do
    expect(provider).to be_an_instance_of Puppet::Type::Vidispine_import_setting::ProviderVidispine_import_setting
  end

  describe 'exists?' do
    it 'should correctly report non-existent import settings' do
      VCR.use_cassette('vidispine_import_setting-exists-false') do
        expect(provider.exists?).to be_falsy
      end
    end

    it 'should correctly find existing import settings' do
      VCR.use_cassette('vidispine_import_setting-exists-true') do
        expect(provider.exists?).to be_truthy
      end
    end
  end

  describe 'create' do
    it 'should create an import setting' do
      VCR.use_cassette('vidispine_import_setting-create') do
        expect(provider.create).to be_truthy
      end
    end
  end

  describe 'destroy' do
    it 'should delete the import setting' do
      VCR.use_cassette('vidispine_import_setting-destroy') do
        expect(provider.destroy).to be_truthy
      end
    end
  end

end

