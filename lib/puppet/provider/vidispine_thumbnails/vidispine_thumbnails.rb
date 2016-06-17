require 'pathname'
require Pathname.new(__FILE__).dirname.dirname.expand_path + 'vidispine'

Puppet::Type.type(:vidispine_thumbnails).provide(:vidispine_thumbnails, :parent => Puppet::Provider::Vidispine) do
  desc "Vidispine Thumbnail resource"

  mk_resource_methods

  def find_vxid
    begin
      response = self.rest_get '/API/resource/thumbnail'

      if response['resource'].nil? then
        return false
      end

      response['resource'].each do |resource|
        path = resource['thumbnail']['path']

        if path == @resource[:name] then
          return resource['id']
        end
      end

      return false

    rescue Exception
      raise Puppet::Error, "Failed to query Vidispine for thumbnail resource #{@resource[:name]}: #{$!}"
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

  def create
    begin
      thumbnail_resource_document = <<-XML.gsub(/^ */, '')
      <resource>
          <thumbnail>
              <path>#{@resource[:name]}</path>
          </thumbnail>
      </resource>
      XML

      self.rest_post '/API/resource/thumbnail', thumbnail_resource_document

    rescue Exception
      raise Puppet::Error, "Failed to create Vidispine thumbnail resource #{@resource[:name]}: #{$!}"
    end
  end

  def destroy
    begin
      vxid = find_vxid()
      self.rest_delete "/API/resource/thumbnail/#{vxid}", { :accept => 'text/plain' }

    rescue Exception
      raise Puppet::Error, "Failed to destroy Vidispine Transcoder resource #{@resource[:name]}: #{$!}"
    end
  end

end
