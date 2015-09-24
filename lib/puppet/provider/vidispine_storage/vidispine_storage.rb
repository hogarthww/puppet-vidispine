require 'pathname'
require Pathname.new(__FILE__).dirname.dirname.expand_path + 'vidispine'

Puppet::Type.type(:vidispine_storage).provide(:vidispine_storage, :parent => Puppet::Provider::Vidispine) do
  desc "Vidispine Storage."

  def check_metadata(storage, key, value)
    metadataFields = storage['metadata']['field']
    metadataFields.each do |metadataField|
      if metadataField['key'] == key && metadataField['value'] == value then
        return true
      end
    end

    return false
  end

  def get_storage
    name = @resource[:name]

    begin
      response = self.rest_get '/API/storage/'

      if response['storage'].nil? then
        return false
      else
        response['storage'].each do |storage|
          if check_metadata(storage, 'storageName', name) then
            return storage
          end
        end

        return false
      end

    rescue Exception
      raise Puppet::Error, "Failed to query Vidispine for Storage #{@resource[:name]}: #{$!}"
    end
  end

  def create
    name = @resource[:name]

    storage_document = <<-XML.gsub(/^ {4}/, '')
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

    existing_storage = get_storage()

    begin
      if existing_storage == false then
        # There is no storage with this name
        self.rest_post '/API/storage/', storage_document
      else
        # There is an existing storage with this name but it has the wrong metadata fields.
        self.rest_put '/API/storage/' + existing_storage['id'], storage_document
      end
    rescue Exception
      raise Puppet::Error, "Failed to create Vidispine Storage #{@resource[:name]}: #{$!}"
    end
  end

  def exists?
    storage = get_storage()

    if storage == false then
      return false
    else
      # A storage with the correct name exists need to check it has the correct metadata.
      # TODO - Check the correct file scan interval is correct
      return storage['id']
    end

  end

  def destroy
    name = @resource[:name]

    begin
      storage = get_storage()
      if storage != false then
        self.rest_delete "/API/storage/" + storage['id']
      end
    
    rescue Exception
      raise Puppet::Error, "Failed to delete Vidispine Storage #{@resource[:name]}: #{$!}"
    end
  end
end
