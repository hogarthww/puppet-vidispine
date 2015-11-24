Puppet::Type.newtype(:vidispine_system_field) do
  @doc = "Manage Vidispine system properties"

  ensurable

  newparam(:key) do
    desc "The name of the system property."
    isnamevar

    validate do |value|
      unless value != ''
         raise ArgumentError, "%s please enter a key name." % value
      end
    end

    munge do |value|
      # Vidispine always returns the keys in lowercase, so we
      # need to make sure our existence checks don't fail
      # because of a case mismatch.
      value.downcase
    end
  end

  newparam(:value) do
    desc "The value for the system property."

    validate do |value|
      unless value != ''
         raise ArgumentError, "%s please enter a value." % value
      end
    end

    munge do |value|
      # Be liberal about what types we accept, but the provider
      # expects to be working with strings, as that's what's sent
      # over the wire to Vidispine's API
      value.to_s
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

end
