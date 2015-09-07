require 'pathname'
require Pathname.new(__FILE__).dirname.dirname.expand_path + 'vidispine'

Puppet::Type.type(:vidispine_system_field).provide(:vidispine_system_field, :parent => Puppet::Provider::Vidispine) do
  desc "Vidispine Configuration Properties"

  def exists?
    name = @resource[:name]
    
    begin
      # Fetch all of the properties at once, to save us handling 404s
      response = self.rest_get '/API/configuration/properties/'

      if response['property'].nil? or not response['property'].is_a? Array then
        return false
      end

      response['property'].each do |property|
        # Both the key and the value have to match. (Fixes TP-526)
        #
        if property['key'] == @resource[:key] and property['value'] == @resource[:value] then
          return true
        end
      end

      # We reached the end of the list and didn't find a match
      return false

    rescue Exception
      raise Puppet::Error, "Failed to query Vidispine for System Field #{@resource[:name]}: #{$!}"
    end

  end

  def create
    begin
      self.rest_put "/API/configuration/properties/#{@resource[:key]}", @resource[:value]

    rescue Exception
      raise Puppet::Error, "Failed to create Vidispine System Field #{@resource[:name]}: #{$!}"
    end
  end

  def destroy
    begin
      self.rest_delete "/API/configuration/properties/#{@resource[:key]}"

    rescue Exception
      raise Puppet::Error, "Failed to delete Vidispine System Field #{@resource[:name]}: #{$!}"
    end
  end

end
