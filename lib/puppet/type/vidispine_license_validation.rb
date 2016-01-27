$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),"..",".."))

require 'puppet/parameter/vidispine_api'
require 'timeout'

Puppet::Type.newtype(:vidispine_license_validation) do

  @doc = "Manage license validation"

  newparam(:name, namevar: true)

  newparam(:timeout) do
    desc 'The length of time, in seconds, to wait for the license to validate before failing.'
    defaultto 60

    validate do |value|
      begin
        Integer(value)
      rescue ArgumentError
        fail "#{value} is not a valid timeout (must be an integer)."
      end
    end

    munge do |value|
      Integer(value)
    end
  end

  def refresh
    Timeout::timeout(self[:timeout], Timeout::Error) do
      while (license_status = provider.license_status) != 'valid' do
        Puppet.debug("Trying to validate Vidispine's license, current status is #{license_status} ...")
        sleep 1
      end

      Puppet.notice('Vidispine license validated successfully')
      return true
    end
  end

  newparam(:vsurl,  :parent => Puppet::Parameter::VidispineAPIURL)
  newparam(:vsuser, :parent => Puppet::Parameter::VidispineUser)
  newparam(:vspass, :parent => Puppet::Parameter::VidispinePassword)

end

