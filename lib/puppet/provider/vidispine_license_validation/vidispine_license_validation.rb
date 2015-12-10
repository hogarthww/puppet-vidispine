require 'pathname'
require Pathname.new(__FILE__).dirname.dirname.expand_path + 'vidispine'

Puppet::Type.type(:vidispine_license_validation).provide(:vidispine_license_validation, :parent => Puppet::Provider::Vidispine) do

  desc "Vidispine license validator"

  def license_status
    response = self.rest_get '/API/version'

    if response['licenseInfo'] and response['licenseInfo']['licenseStatus'] then
      return response['licenseInfo']['licenseStatus']
    end

    return nil
  end

  def exists?
    # Is the license valid already? Check and return true/false straight away

    if license_status == 'valid' then
      return true
    else
      return false
    end
  end

  def create
    # Wait for the system to finish validating.
    # Keep polling the status until it changes to 'valid' or the timeout expires

    @resource[:timeout].times do
      if license_status == 'valid' then
        return true
      else
        sleep 1
      end
    end

    #return false
    raise Puppet::Error, 'Timed out waiting for the license to validate.'
  end

  # We don't expect the destroy method to ever be used, although it may be required
  def destroy
    return true
  end

end

