require 'rubygems'
require 'json'
require 'net/http'
require 'uri'

Puppet::Type.type(:vidispine_import_setting).provide(:vidispine_import_setting) do
  desc "Vidispine import setting"

  def create
  permission   = @resource[:permission]
  vsurl  = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/import/settings/"
  vsuser = @resource[:vsuser]
  vspass = @resource[:vspass]
  group  = @resource[:group]
  uri = URI(vsurl)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri)
  request.basic_auth @resource[:vsuser], @resource[:vspass]
  request.body = <<xml
<ImportSettingsDocument xmlns="http://xml.vidispine.com/schema/vidispine">
   <access>
      <permission>#{permission}</permission>
      <group>#{group}</group>
   </access>
</ImportSettingsDocument>
xml
  request["Content-Type"] = "application/xml"
  response = http.request(request)
  if response.code != '200' then return false end
  end

  def exists?
    name   = @resource[:name]
    vsurl  = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/import/settings/"
    vsuser = @resource[:vsuser]
    vspass = @resource[:vspass]
    group  = @resource[:group]
    uri = URI.parse(vsurl)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth vsuser, vspass
    request["Accept"] = "application/json"
    response = http.request(request)
    if response.body == 'null' || response.body == '{}' then return false end
    parsed = JSON.parse(response.body)
    uriList = parsed["uri"]
    uriList.each do |settingUri|
      settingUrl = URI.parse(vsurl + settingUri)
      settingHttp = Net::HTTP.new(settingUrl.host, settingUrl.port)
      settingRequest = Net::HTTP::Get.new(settingUrl.request_uri)
      settingRequest.basic_auth vsuser, vspass
      settingRequest["Accept"] = "application/json"
      settingResponse = http.request(settingRequest)
      settingJSON = JSON.parse(settingResponse.body)
      settingGroup = settingJSON["access"][0]["group"]
      if settingGroup == group then return settingJSON["id"] end      
    end
    return false
  end
  def destroy
    settingId = exits?()
    vsurl  = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/import/settings/" + settingId
    vsuser = @resource[:vsuser]
    vspass = @resource[:vspass]    
    uri = URI(vsurl)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(uri.request_uri)
    request.basic_auth vsuser, vspass
    request["Accept"] = "application/json"
    response = http.request(request)
  end
end
