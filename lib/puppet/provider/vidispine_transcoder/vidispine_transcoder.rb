require 'pathname'
require Pathname.new(__FILE__).dirname.dirname.expand_path + 'vidispine'

Puppet::Type.type(:vidispine_transcoder).provide(:vidispine_transcoder, :parent => Puppet::Provider::Vidispine) do
  desc "Vidispine Transcoder resource"

  def find_vxid
    begin
      response = self.rest_get '/API/resource/transcoder'

      if response['resource'].nil? then
        return false
      end

      response['resource'].each do |resource|
        url = resource['transcoder']['url']

        if url == @resource[:url] then
          return resource['id']
        end
      end

      return false

    rescue Exception
      raise Puppet::Error, "Failed to query Vidispine for Transcoder resource #{@resource[:name]}: #{$!}"
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
      transcoder_resource_document = <<-XML.gsub(/^ */, '')
      <resource>
        <transcoder>
          <url>#{@resource[:url]}</url>
        </transcoder>
      </resource>
      XML

      self.rest_post '/API/resource/transcoder', transcoder_resource_document

    rescue Exception
      raise Puppet::Error, "Failed to create Vidispine Transcoder resource #{@resource[:name]}: #{$!}"
    end
  end
  
  def destroy
    begin
      vxid = find_vxid()
      self.rest_delete "/API/resource/transcoder/#{vxid}"

    rescue Exception
      raise Puppet::Error, "Failed to destroy Vidispine Transcoder resource #{@resource[:name]}: #{$!}"
    end
  end

end
