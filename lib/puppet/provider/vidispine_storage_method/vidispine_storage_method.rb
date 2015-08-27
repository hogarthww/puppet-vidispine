require 'pathname'
require Pathname.new(__FILE__).dirname.dirname.expand_path + 'vidispine'

Puppet::Type.type(:vidispine_storage_method).provide(:vidispine_storage_method, :parent => Puppet::Provider::Vidispine) do
  desc "Vidispine Storage Method"

  def create
    name = @resource[:name]

    begin
      parent = findParent()
      uripath = sprintf("/API/storage/%s/method?url=%s&read=%s&browse=%s&write=%s&type=%s",
        parent,
        @resource[:storageuri],
        @resource[:read].to_s,
        @resource[:write].to_s,
        @resource[:browse].to_s,
        @resource[:type])

      # We're PUTting a zero length document. All the work is done by the query string.
      self.rest_put uripath, nil

    rescue Exception
      raise Puppet::Error, "Failed to create Vidispine Storage Method #{name}: #{$!}"
    end
  end


  # The following method re-implements the exists? method of the vidispine_storage provider.
  #
  # I think that if vidispine_storage implements self.prefetch, this won't be needed,
  # as all the storage resources will already have been pre-instantiated.
  #
  def findParent
    # This is the only difference: search for the storage using the storage_method's
    # location attribute.
    name = @resource[:location]

    begin
      response = self.rest_get '/API/storage/'
      storages = response["storage"]

      storages.each do |storage|
        metadataFields = storage["metadata"]["field"]
        metadataFields.each do |metadataField|
          if metadataField['key'] == 'storageName' && metadataField['value'] == name then
            return storage['id']
          end
        end
      end

      return false

    rescue Exception
      raise Puppet::Error, "Failed to query Vidispine for Storage #{name}: #{$!}"
    end
  end


  #there's a possible bug here to do with changing a storage metod and getting a different vxid.
  #not sure what to do about this but at this prsent moment i dont care
  def exists?
    parent = findParent
    vsurl  = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/storage/"+ parent + "/method"
    name   = @resource[:name]
    vsuser = @resource[:vsuser]
    vspass = @resource[:vspass]
    uri = URI.parse(vsurl)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth vsuser, vspass
    request["Accept"] = "application/json"
    response = http.request(request)
    if response.body == 'null' || response.body == '{}' then return false end
    parsed = JSON.parse(response.body)
    methods = parsed["method"]
    methods.each do |method|
       uri  = method['uri']
       if uri == @resource[:storageuri]
       then
#         return method['id']
          return true
       end
    end
   return false
  end
  
  def destroy
    parent = findParent()
    id = exists?()
    vsurl  = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/storage/"+ parent + "/method/" + id
    name   = @resource[:name]
    vsuser = @resource[:vsuser]
    vspass = @resource[:vspass]

    # Need to find storage method VX-ID

    uri = URI.parse(vsurl)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(uri.request_uri)
    request.basic_auth vsuser, vspass
    request["Accept"] = "application/json"
    response = http.request(request)
  end
end
