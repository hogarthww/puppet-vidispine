require 'puppet/parameter/vidispine_api'

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

  newparam(:vsurl,  :parent => Puppet::Parameter::VidispineAPIURL)
  newparam(:vsuser, :parent => Puppet::Parameter::VidispineUser)
  newparam(:vspass, :parent => Puppet::Parameter::VidispinePassword)

end
