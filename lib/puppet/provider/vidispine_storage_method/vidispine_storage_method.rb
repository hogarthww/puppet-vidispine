require 'pathname'
require Pathname.new(__FILE__).dirname.dirname.expand_path + 'vidispine'

Puppet::Type.type(:vidispine_storage_method).provide(:vidispine_storage_method, :parent => Puppet::Provider::Vidispine) do
  desc "Vidispine Storage Method"

  # The following method re-implements the exists? method of the vidispine_storage provider.
  #
  # I think that if vidispine_storage implements self.prefetch, this won't be needed,
  # as all the storage resources will already have been pre-instantiated.
  #
  def find_parent
    # This is the only difference: search for the storage using the storage_method's
    # location attribute.
    name = @resource[:location]

    begin
      response = self.rest_get '/API/storage/'

      if response['storage'].nil? then
        return false
      else
        response['storage'].each do |storage|
          metadataFields = storage["metadata"]["field"]
          metadataFields.each do |metadataField|
            if metadataField['key'] == 'storageName' && metadataField['value'] == name then
              return storage['id']
            end
          end
        end

        return false
      end

    rescue Exception
      raise Puppet::Error, "Failed to query Vidispine for Storage #{name}: #{$!}"
    end
  end


  def find_vxid
    begin
      parent = find_parent()

      # Perhaps the location attribute points to a nonexistent storage? In that case
      # parent will be set to false by the find_parent method, and we already know
      # the storage_method doesn't exist as described.
      #
      if parent == false then
        return false
      end

      response = self.rest_get "/API/storage/#{parent}/method"

      unless response['method'].nil? then
        response['method'].each do |method|
          uri = method['uri']
          if uri == @resource[:storageuri]
          then
            return method['id']
          end
        end
      end

      return false

    rescue Exception
      raise Puppet::Error, "Failed to query Vidispine for Storage Method #{name}: #{$!}"
    end
  end


  def create
    name = @resource[:name]

    begin
      parent = find_parent()
      uripath = sprintf("/API/storage/%s/method?url=%s&read=%s&browse=%s&write=%s&type=%s",
        parent,
        @resource[:storageuri],
        @resource[:read].to_s,
        @resource[:write].to_s,
        @resource[:browse].to_s,
        @resource[:type])

      # We're PUTting a zero length document. All the work is done by the query string.
      # This is an inconsistent API call in general as requesting application/xml or
      # application/json results in an error! However, text/plain works.
      self.rest_put uripath, nil, { :accept => 'text/plain' }

    rescue Exception
      raise Puppet::Error, "Failed to create Vidispine Storage Method #{name}: #{$!}"
    end
  end


  def exists?
    # An existence check is exactly the same as finding the VX-ID, but we always
    # want to return a boolean value
    #
    if find_vxid then
      return true
    else
      return false
    end
  end


  def destroy
    begin
      # FIXME: This is a bit sucky as we end making three GETs to /API/storage
      # followed by a DELETE, where one GET and one DELETE would do fine.
      #
      parent = find_parent()
      id = find_vxid()
      self.rest_delete "/API/storage/#{parent}/method/#{id}"

    rescue Exception
      raise Puppet::Error, "Failed to destroy Vidispine Storage Method #{name}: #{$!}"
    end
  end
end
