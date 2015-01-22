require 'rubygems'
require 'json'
require 'net/http'
require 'uri'

Puppet::Type.type(:vidispine_thumbnails).provide(:vidispine_thumbnails) do
  desc "Vidispine transcoder."

  def create
  vsurl  = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/resource/thumbnail"
  name   = @resource[:name]
  vsuser = @resource[:vsuser]
  vspass = @resource[:vspass]
    uri = URI(vsurl)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth @resource[:vsuser], @resource[:vspass]
    request.body = <<"xml"
    <resource>
        <thumbnail>
            <path>#{name}</path>
        </thumbnail>
    </resource>
xml
    request["Content-Type"] = "application/xml"
    response = http.request(request)
   end

  def exists?
    vsurl  = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/resource/thumbnail"
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
    resources = parsed["resource"]
    resources.each do |resource|
       path = resource["thumbnail"]["path"]
       if path == name
       then
         return true
       end
    end
   return false
  end
  def destroy
    vsurl  = "http://" + @resource[:vshostname] +":"+ @resource[:vsport] + "/API/resource/thumbnail/"
    name   = @resource[:name]
    name   = name + "/"
    vsuser = @resource[:vsuser]
    vspass = @resource[:vspass]
    uri = URI.parse(vsurl)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth vsuser, vspass
    request["Accept"] = "application/json"
    response = http.request(request)
    parsed = JSON.parse(response.body)
    resources = parsed["resource"]
    resources.each do |resource|
       path = resource["thumbnail"]["path"]
       if path == name
       then
          vxid = resource["id"]
          Puppet.debug("deleting VX-id " + vxid)
          uri = URI(vsurl + vxid)
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Delete.new(uri.request_uri)
          request.basic_auth vsuser, vspass
          request["Accept"] = "application/json"
          response = http.request(request)
       end
    end
  end
end
