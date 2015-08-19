require 'json'
require 'net/http'
require 'uri'

Puppet::Type.type(:vidispine_system_field).provide(:vidispine_system_field) do
  desc "Vidispine system configuration."

  def create
  name   = @resource[:name]
  vsurl  = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/configuration/properties/" + name
  vsuser = @resource[:vsuser]
  vspass = @resource[:vspass]
  value  = @resource[:value]
  uri = URI(vsurl)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Put.new(uri.request_uri)
  request.basic_auth @resource[:vsuser], @resource[:vspass]
  request.body = value
  request["Content-Type"] = "text/plain"
  response = http.request(request)
  end

  def exists?
    name   = @resource[:name]
    vsurl  = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/configuration/properties/" + name
    vsuser = @resource[:vsuser]
    vspass = @resource[:vspass]
    value  = @resource[:value]
    uri = URI.parse(vsurl)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth vsuser, vspass
    request["Accept"] = "application/json"
    response = http.request(request)
    if response.code == '200' then 
      return true
    elsif response.code == '404' then
      return false
    else
      raise Puppet::Error, "Vidispine responded with HTTP #{response.code}: \"#{response.body}\""
    end
    return false
  end
  def destroy
    name   = @resource[:name]
    vsurl  = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/configuration/properties/" + name
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
