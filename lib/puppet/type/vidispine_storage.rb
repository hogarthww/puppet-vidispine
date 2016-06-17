$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),"..",".."))

require 'puppet/parameter/vidispine_api'

Puppet::Type.newtype(:vidispine_storage) do
  @doc = "Vidispine Storage"

  ensurable

  newparam(:name) do
    desc "The name for the Storage."
    isnamevar

    validate do |value|
      unless value != ''
        raise ArgumentError, "%s please enter a storage name" % value
      end
    end
  end

  newparam(:scan_interval) do
    desc "The scanInterval in seconds. Defaults to 60."

    defaultto 60

    # Basic integer validation using Ruby's type system. Puppet passes
    # integer literals in the Puppet DSL into Ruby as strings (!), 
    # we also want to accept quoted integers.
    #
    validate do |value|
      begin
        Integer(value)
      rescue ArgumentError
        raise ArgumentError, "%s is not a integer." % value
      end
    end
    
    munge do |value|
      Integer(value)
    end
  end

  newparam(:vsurl,  :parent => Puppet::Parameter::VidispineAPIURL)
  newparam(:vsuser, :parent => Puppet::Parameter::VidispineUser)
  newparam(:vspass, :parent => Puppet::Parameter::VidispinePassword)

end

