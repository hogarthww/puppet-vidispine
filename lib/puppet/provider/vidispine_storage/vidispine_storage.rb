require 'pathname'
require Pathname.new(__FILE__).dirname.dirname.expand_path + 'vidispine'

Puppet::Type.type(:vidispine_storage).provide(:vidispine_storage, :parent => Puppet::Provider::Vidispine) do
  desc "Vidispine Storage."

  def create
    name = @resource[:name]

    begin
      storage_document = <<-XML.gsub(/^ {6}/, '')
      <StorageDocument xmlns="http://xml.vidispine.com/schema/vidispine">
          <metadata>
            <field>
              <key>storageName</key>
              <value>#{name}</value>
            </field>
          </metadata>
          <autoDetect>true</autoDetect>
      </StorageDocument>
      XML

      self.rest_post '/API/storage/', storage_document

    rescue Exception
      raise Puppet::Error, "Failed to create Vidispine Storage #{@resource[:name]}: #{$!}"
    end
  end

  def exists?
    name = @resource[:name]

    begin
      response = self.rest_get '/API/storage/'

      if response['storage'].nil? then
        return false
      else
        response['storage'].each do |storage|
          metadataFields = storage['metadata']['field']
          metadataFields.each do |metadataField|
            if metadataField['key'] == 'storageName' && metadataField['value'] == name then
              return storage['id']
            end
          end
        end

        return false
      end

    rescue Exception
      raise Puppet::Error, "Failed to query Vidispine for Storage #{@resource[:name]}: #{$!}"
    end
  end

  def destroy
    name = @resource[:name]

    begin
      id = exists?()
      if not id == false then
        self.rest_delete "/API/storage/" + id
      end
    
    rescue Exception
      raise Puppet::Error, "Failed to delete Vidispine Storage #{@resource[:name]}: #{$!}"
    end
  end
end
