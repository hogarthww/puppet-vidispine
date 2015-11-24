require 'uri'

Puppet::Type.newtype(:vidispine_thumbnails) do
  @doc = "Manage Vidispine transcoder address"

  ensurable

  newparam(:path) do
    desc "The Transcoder address."
    isnamevar

  validate do |value|
      unless value =~ /\A#{URI::regexp}\z/
         raise ArgumentError, "%s is not a valid address." % value
      end
    end
  end
  newparam(:vshostname) do
    desc "The hostname of the vidispine API."

    validate do |value|
      unless value =~ /^[\w-]+$/
        raise ArgumentError, "%s is not a valid address." % value
      end
    end
  end
  newparam(:vsport) do
    desc "The port of the vidispine API."

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
    desc "The Username for vidispine API."

    validate do |value|
      unless value =~ /^[\w-]+$/
        raise ArgumentError, "%s is not a valid address." % value
      end
    end
  end
    newparam(:vspass) do
    desc "The password for the vidispine API."

    validate do |value|
      unless value =~ /^[\w-]+$/
        raise ArgumentError, "%s is not a valid address." % value
      end
    end
  end


end
