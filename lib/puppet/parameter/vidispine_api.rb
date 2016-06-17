require 'puppet/parameter'

class Puppet::Parameter::VidispineAPIURL < Puppet::Parameter
  desc "The URL by which to reach the Vidispine API"

  validate do |value|
    unless value =~ /\A#{URI::regexp(['http', 'https'])}\z/
      fail "#{value} is not a valid URL."
    end
  end

  munge do |value|
    # Add a trailing slash to the URL if it isn't there,
    # leave it alone if it's there already.
    value.gsub(/^(.*?)\/*$/, '\1/')
  end
end

class Puppet::Parameter::VidispineUser < Puppet::Parameter
  desc "The username for Vidispine API."
  
  validate do |value|
    unless value =~ /^[\w-]+$/
      raise ArgumentError, "%s is not a valid username." % value
    end
  end
end

class Puppet::Parameter::VidispinePassword < Puppet::Parameter
  desc "The password for the Vidispine API."

  validate do |value|
    unless value =~ /^[\w-]+$/
      raise ArgumentError, "%s is not a valid password." % value
    end
  end
end

