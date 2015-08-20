Puppet::Type.newtype(:vidispine_storage) do
  @doc = "Manage Vidispine storage provider"

  ensurable

  newparam(:name) do
    desc "the vidispine VX-ID for the storage."
    isnamevar

  validate do |value|
      unless value != ''
         raise ArgumentError, "%s please enter a storage name" % value
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

    validate do |value|
      unless value =~ /^\d+$/
        raise ArgumentError, "%s is not a valid port number." % value
      end
    end
  end
  newparam(:vsuser) do
    desc "The Username for vidispine API."

    validate do |value|
      unless value =~ /^[\w-]+$/
        raise ArgumentError, "%s is not a valid username." % value
      end
    end
  end
    newparam(:vspass) do
    desc "The password for the vidispine API."

    validate do |value|
      unless value =~ /^[\w-]+$/
        raise ArgumentError, "%s is not a valid password." % value
      end
    end
  end


end
