require 'spec_helper'

type_class = Puppet::Type.type(:vidispine_license_validation)

describe type_class do

  before :each do
    type_class.stubs(:defaultprovider).returns providerclass
  end

  let :providerclass do
    type_class.provide(:mock_license_validator) do
      def initialize(resource = nil)
        @checks_done = 0
        @validates_after = 2
      end

      def license_status
        puts "checks_done = #{@checks_done}, validates_after = #{@validates_after}"

        if @checks_done == @validates_after then
          return 'valid'
        else
          @checks_done += 1
          return 'invalid'
        end
      end
    end
  end

  let :provider do
    providerclass.new
  end

  let :resource do
    type_class.new(:name => 'rspec', :provider => provider)
  end

  describe 'refresh' do
    it 'should refresh successfully when the license validates' do
      resource[:timeout] = 3
      expect(resource.refresh).to be_truthy
    end
    it 'should fail when the timeout expires before validation completes' do
      resource[:timeout] = 2
      expect { resource.refresh }.to raise_error(Timeout::Error)
    end
  end
 
end

