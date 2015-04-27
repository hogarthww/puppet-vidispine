require 'rubygems'
require 'pathname'
require Pathname.new(__FILE__).dirname.dirname.expand_path + 'vidispine'

Puppet::Type.type(:vidispine_storage).provide(:vidispine_storage, :parent => Puppet::Provider::Vidispine) do
  desc "Vidispine Storage."

  def create
    name = @resource[:name]

    begin
      self.rest_post '/API/storage/', <<xml
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
    rescue Exception
      raise Puppet::Error, "Failed to create Vidispine Storage #{name}: #{$!}"
    end
  end

  def exists?
    name = @resource[:name]
    
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

  def destroy
    name = @resource[:name]

    begin
      id = exists?()
      if not id == false then
        self.rest_delete "/API/storage/" + id
      end
    
    rescue Exception
      raise Puppet::Error, "Failed to delete Vidispine Storage #{name}: #{$!}"
    end
  end
end
