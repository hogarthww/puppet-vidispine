$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),"..",".."))

require 'uri'
require 'puppet/parameter/vidispine_api'

Puppet::Type.newtype(:vidispine_storage_method) do
  @doc = "Manage Vidispine storage methods address"

  ensurable

  newparam(:name) do
    desc "The name of the Storage Method resource."
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
    desc "The Storage that this Storage Method applies to"

    validate do |value|
      unless value != ''
        raise ArgumentError, "%s please enter a valid parent name" % value
      end
    end
  end

  newparam(:read) do
    desc "Boolean value: whether or not the Storage is readable via this method"

    validate do |value|
      value_s = value.to_s
      unless value_s == 'true' || value_s == 'false'
        raise ArgumentError, "%s valid params are booleans or strings containing 'true' or 'false'." % value
      end
    end

    munge do |value|
      value.to_s
    end
  end

  newparam(:write) do
    desc "Boolean value: whether or not the Storage is writable via this method"

    validate do |value|
      value_s = value.to_s
      unless value_s == 'true' || value_s == 'false'
        raise ArgumentError, "%s valid params are strings containing true of false." % value
      end
    end

    munge do |value|
      value.to_s
    end
  end

  newparam(:browse) do
    desc "Boolean value: whether or not the Storage is browsable via this method"

    validate do |value|
      value_s = value.to_s
      unless value_s == 'true' || value_s == 'false'
        raise ArgumentError, "%s valid params are strings containing true of false." % value
      end
    end

    munge do |value|
      value.to_s
    end
  end

  newparam(:type) do
    desc "The Vidispine Storage Method Type."
    defaultto "NONE"

    validate do |value|
      unless value == 'AUTO' || value == 'NONE'
        raise ArgumentError, "%s valid params are strings containing AUTO or NONE." % value
      end
    end
  end

  newparam(:vsurl,  :parent => Puppet::Parameter::VidispineAPIURL)
  newparam(:vsuser, :parent => Puppet::Parameter::VidispineUser)
  newparam(:vspass, :parent => Puppet::Parameter::VidispinePassword)

end
