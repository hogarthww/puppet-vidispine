require 'uri'

Puppet::Type.newtype(:transcoder_address) do
  @doc = "Vidispine transcoder address"

  ensurable

  newparam(:hostname) do
    desc "The Transcoder URL."
    isnamevar

    validate do |value|
      unless value =~ /\A#{URI::regexp(['http', 'https'])}\z/
         raise ArgumentError, "%s is not a valid address." % value
      end
    end

    munge do |value|
      # Add a trailing slash to the URL if it isn't there,
      # leave it alone if it's there already.
      value.gsub(/^(.*?)\/*$/, '\1/')
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

    validate do |value|
      unless value =~ /^\d+$/
        raise ArgumentError, "%s is not a valid port number." % value
      end
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

