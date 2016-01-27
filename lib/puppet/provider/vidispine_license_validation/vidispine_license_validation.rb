require 'pathname'
require Pathname.new(__FILE__).dirname.dirname.expand_path + 'vidispine'

Puppet::Type.type(:vidispine_license_validation).provide(:vidispine_license_validation, :parent => Puppet::Provider::Vidispine) do

  desc "Vidispine license validator"

  mk_resource_methods

  def license_status
    response = self.rest_get '/API/version'

    if response['licenseInfo'] and response['licenseInfo']['licenseStatus'] then
      return response['licenseInfo']['licenseStatus']
    end

    return nil
  end

end

