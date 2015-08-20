require 'uri'

Puppet::Type.newtype(:vidispine_storage_method) do
  @doc = "Manage Vidispine storage methods address"

  ensurable

  newparam(:name) do
    desc "The name of the storage_method resource."
  end

  newparam(:storageuri) do
    desc "The Storage URI for vidispine."

    validate do |value|
      unless value =~ /\A#{URI::regexp}\z/
         raise ArgumentError, "%s is not a valid storage address." % value
      end
    end
  end

  newparam(:location) do
    desc "The parent that this storage method applies to"

    validate do |value|
      unless value != ''
        raise ArgumentError, "%s please enter a valid parent name" % value
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
  newparam(:read) do
    desc "strung value - true or false dependant on if a storage is readable "

    validate do |value|
      unless value == 'true' || value == 'false'
        raise ArgumentError, "%s valid params are strings containing true of false." % value
      end
    end
  end
  newparam(:write) do
    desc "The password for the vidispine API."

    validate do |value|
       unless value == 'true' || value == 'false'
        raise ArgumentError, "%s valid params are strings containing true of false." % value
      end
    end
  end
  newparam(:browse) do
    desc "The password for the vidispine API."

    validate do |value|
       unless value == 'true' || value == 'false'
        raise ArgumentError, "%s valid params are strings containing true of false." % value
      end
    end
  end

  newparam(:type) do
    desc "The Vidispine storeage_method type."
    defaultto "NONE"

    validate do |value|
       unless value == 'AUTO' || value == 'NONE'
        raise ArgumentError, "%s valid params are strings containing AUTO or NONE." % value
      end
    end
  end

end
