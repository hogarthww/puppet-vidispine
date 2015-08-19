require 'json'
require 'net/http'
require 'uri'

Puppet::Type.type(:vidispine_storage_method).provide(:vidispine_storage_method) do
  desc "Vidispine Storage method provider."

#this is a bit odd - because we dont actually use XML but a put to an existing storage
#this means that all the work is done by the vsquery param (yay?)

  def create
    parent = findParent()
    name    = @resource[:name]
    vsurl   = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/storage/" + parent + "/method"
    vsquery = "url="+ @resource[:storageuri] +"&read="+ @resource[:read] +"&browse="+ @resource[:write] +"&write=" + @resource[:browse] +"&type=" + @resource[:type]
    vsurl   = vsurl + "?" + vsquery
    vsuser  = @resource[:vsuser]
    vspass  = @resource[:vspass]
    uri     = URI(vsurl)
    http    = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Put.new(uri.request_uri)
    request.basic_auth @resource[:vsuser], @resource[:vspass]
    request["Content-Type"] = "application/xml"
    response = http.request(request)
  end
 
  #because we need to find the parent by a feild in the metadata (and these functions are difficult to share)
  #we need to re-define the call that works out if the parent exists and returns its VX-ID

  def findParent
    vsurl  = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/storage/"
    name   = @resource[:location]
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
    storages = parsed["storage"]
    storages.each do |storage|
       metadataFields = storage["metadata"]["field"]
       metadataFields.each do |metadataField|
         if metadataField['key'] == 'storageName' && metadataField['value'] == name then
           return storage['id']
         end
       end
    end
    return false
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
