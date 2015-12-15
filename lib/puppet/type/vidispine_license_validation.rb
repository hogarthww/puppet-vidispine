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

  # Common params - connection details to the Vidispine API

  newparam(:vshostname) do
    desc "The hostname of the Vidispine API."

    validate do |value|
      unless value =~ /^[\w-]+$/
        raise ArgumentError, "%s is not a valid address." % value
      end
    end
  end

  newparam(:vsport) do
    desc "The port of the Vidispine API."

    # Basic integer validation using Ruby's type system. Puppet passes
    # integer literals in the Puppet DSL into Ruby as strings (!), 
    # we also want to accept quoted integers.
    #
    validate do |value|
      begin
        Integer(value)
      rescue ArgumentError
        raise ArgumentError, "%s is not a valid port number." % value
      end
    end

    munge do |value|
      Integer(value)
    end
  end

  newparam(:vsuser) do
    desc "The username for Vidispine API."

    validate do |value|
      unless value =~ /^[\w-]+$/
        raise ArgumentError, "%s is not a valid username." % value
      end
    end
  end

  newparam(:vspass) do
    desc "The password for the Vidispine API."

    validate do |value|
      unless value =~ /^[\w-]+$/
        raise ArgumentError, "%s is not a valid password." % value
      end
    end
  end

end

