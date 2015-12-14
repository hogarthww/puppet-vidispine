require 'spec_helper'

provider_class = Puppet::Type.type(:vidispine_license_validation).provider(:vidispine_license_validation)

describe provider_class do

  let(:resource) {
    Puppet::Type.type(:vidispine_license_validation).new(
      :name       => 'rspec',
      :vshostname => 'localhost',
      :vsport     => '8080',
      :vsuser     => 'admin',
      :vspass     => 'admin',
      :timeout    => 2,
    )
  }

  let(:provider) { resource.provider }

  describe 'license_status' do
    it 'should return "valid" when the license is valid' do
      VCR.use_cassette('vidispine_license_validation-is-valid') do
        expect(provider.license_status).to eq('valid')
      end
    end

    it 'should not return "valid" unless the license is valid' do
      VCR.use_cassette('vidispine_license_validation-is-not-valid') do
        expect(provider.license_status).not_to eq('valid')
      end
    end
  end

end

