require 'rubygems'
require 'json'
require 'net/http'
require 'uri'

Puppet::Type.type(:vidispine_storage).provide(:vidispine_storage) do
  desc "Vidispine Storage."

  def create
  vsurl  = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/storage/"
  name   = @resource[:name]
  vsuser = @resource[:vsuser]
  vspass = @resource[:vspass]
    uri = URI(vsurl)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth @resource[:vsuser], @resource[:vspass]
    request["Content-Type"] = "application/xml"
    request.body = <<xml
<StorageDocument xmlns="http://xml.vidispine.com/schema/vidispine">
    <metadata>
      <field>
        <key>storageName</key>
        <value>#{name}</value>
      </field>
    </metadata>
    <autoDetect>true</autoDetect>
</StorageDocument>
xml
    response = http.request(request)

    if response.code != 200 then
      raise Puppet::Error, "Failed to create Vidispine Storage #{name}: Vidispine responded with HTTP #{response.code}: \"#{response.body}\""
    end
   end

  def exists?
    vsurl  = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/storage/"
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
  def destroy
    id = exists?()
    vsurl  = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/storage/" + id
    name   = @resource[:name]
    vsuser = @resource[:vsuser]
    vspass = @resource[:vspass]
    uri = URI.parse(vsurl)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(uri.request_uri)
    request.basic_auth vsuser, vspass
    request["Accept"] = "application/json"
    response = http.request(request)
  end
end
