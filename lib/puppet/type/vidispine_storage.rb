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
end

