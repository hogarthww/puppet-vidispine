Puppet::Type.newtype(:vidispine_system_field) do
  @doc = "Manage Vidispine system properties"

  ensurable

  newparam(:key) do
    desc "The system key."
    isnamevar

    validate do |value|
      unless value != ''
         raise ArgumentError, "%s please enter a keyname." % value
      end
    end
  end

  newparam(:value) do
    desc "The value for said key."

    validate do |value|
      unless value != ''
         raise ArgumentError, "%s please enter a keyname." % value
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
