require 'spec_helper'

provider_class = Puppet::Type.type(:vidispine_system_field).provider(:vidispine_system_field)

describe provider_class do

  let(:name) { 'rspec vidispine_system_field test' }

  let(:resource) { Puppet::Type.type(:vidispine_system_field).new(
      :key        => 'rspec_system_field',
      :value      => '3ed0cc7c714f530fc2919d369335a1d280fd9686',
      :vshostname => 'localhost',
      :vsport     => '8080',
      :vsuser     => 'admin',
      :vspass     => 'admin'
      )}

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it "should be an instance of Puppet::Type::Vidispine_system_field::ProviderVidispine_system_field" do
    expect(provider).to be_an_instance_of Puppet::Type::Vidispine_system_field::ProviderVidispine_system_field
  end

  describe 'exists?' do
    it 'should correctly report non-existent system fields' do
      VCR.use_cassette('vidispine_system_field-exists-false') do
        expect(provider.exists?).to be_falsy
      end
    end

    it 'should correctly find existing system fields' do
      VCR.use_cassette('vidispine_system_field-exists-true') do
        expect(provider.exists?).to be_truthy
      end
    end
  end

  describe 'create' do
    it 'should create a system field' do
      VCR.use_cassette('vidispine_system_field-create') do
        expect(provider.create).to be_truthy
      end
    end
  end

  describe 'destroy' do
    it 'should delete a system field' do
      VCR.use_cassette('vidispine_system_field-destroy') do
        expect(provider.destroy).to be_truthy
      end
    end
  end

end

