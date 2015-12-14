require 'uri'
require 'puppet/parameter/vidispine_api'

Puppet::Type.newtype(:vidispine_thumbnails) do
  @doc = "Manage Vidispine thumbnail resources"

  ensurable

  newparam(:path) do
    desc "The thumbnail resource URL."
    isnamevar

    validate do |value|
      unless value =~ /\A#{URI::regexp}\z/
         raise ArgumentError, "%s is not a valid URL." % value
      end
    end
  end

  newparam(:vsurl,  :parent => Puppet::Parameter::VidispineAPIURL)
  newparam(:vsuser, :parent => Puppet::Parameter::VidispineUser)
  newparam(:vspass, :parent => Puppet::Parameter::VidispinePassword)

end
