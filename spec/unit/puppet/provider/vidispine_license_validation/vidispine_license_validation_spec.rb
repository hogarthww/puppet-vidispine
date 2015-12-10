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

  describe 'exists?' do
   it 'should return true when the license is valid' do
     VCR.use_cassette('vidispine_license_validation-exists-true') do
       expect(provider.exists?).to be_truthy
     end
   end

   it 'should return false when the license is not valid' do
     VCR.use_cassette('vidispine_license_validation-exists-false') do
       expect(provider.exists?).to be_falsy
     end
   end
  end

  describe 'create' do
    it 'should fail the Puppet run if the license validation times out' do
       VCR.use_cassette('vidispine_license_validation-create-timeout') do
         expect { provider.create }.to raise_error(Puppet::Error, /Timed out waiting for the license to validate/)
       end
     end

     it 'should return true when the license validates' do
       VCR.use_cassette('vidispine_license_validation-create-true') do
         expect(provider.create).to be_truthy
       end
     end
  end
end

