$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),"..",".."))

require 'uri'
require 'puppet/parameter/vidispine_api'

Puppet::Type.newtype(:vidispine_transcoder) do
  @doc = "Vidispine transcoder"

  ensurable

  newparam(:url) do
    isnamevar
    desc "The Transcoder URL"

    validate do |value|
      unless value =~ /\A#{URI::regexp(['http', 'https'])}\z/
         raise ArgumentError, "%s is not a URL." % value
      end
    end

    munge do |value|
      # Add a trailing slash to the URL if it isn't there,
      # leave it alone if it's there already.
      value.gsub(/^(.*?)\/*$/, '\1/')
    end
  end

  newparam(:vsurl,  :parent => Puppet::Parameter::VidispineAPIURL)
  newparam(:vsuser, :parent => Puppet::Parameter::VidispineUser)
  newparam(:vspass, :parent => Puppet::Parameter::VidispinePassword)

end

