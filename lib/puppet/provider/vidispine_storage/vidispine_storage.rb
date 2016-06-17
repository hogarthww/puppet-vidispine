require 'pathname'
require Pathname.new(__FILE__).dirname.dirname.expand_path + 'vidispine'

Puppet::Type.type(:vidispine_storage).provide(:vidispine_storage, :parent => Puppet::Provider::Vidispine) do
  desc "Vidispine Storage."

  mk_resource_methods

#-- Helper methods ------------------------------------------------------------#
  def check_metadata(storage, key, value)
    # The metadata come as an array of hashes, so we need to loop through the
    # array and check each hash for the key value pair.
    metadataFields = storage['metadata']['field']
    metadataFields.each do |metadataField|
      if metadataField['key'] == key && metadataField['value'] == value then
        return true
      end
    end

    return false
  end

  def get_storage
    # TODO - Cache the storage if we get one so we don't hammer Vidispine
    #        everytime we run puppet.
    begin
      response = self.rest_get '/API/storage/'

      if not response['storage'].nil? then
        # We need to loop through all the storages that have been returned to
        # see if there is one with the correct name.
        response['storage'].each do |storage|
          if check_metadata(storage, 'storageName', @resource[:name]) then
            return storage
          end
        end
      end

      # Either there were no storages or none of the storages that were returned
      # had the correct name.
      return false

    rescue Exception
      raise Puppet::Error, "Failed to query Vidispine for Storage #{@resource[:name]}: #{$!}"
    end
  end

#-- Actual methods ------------------------------------------------------------#
  def create
    storage_document = <<-XML.gsub(/^ {4}/, '')
    <StorageDocument xmlns="http://xml.vidispine.com/schema/vidispine">
      <metadata>
        <field>
          <key>storageName</key>
          <value>#{@resource[:name]}</value>
        </field>
      </metadata>
      <scanInterval>#{@resource[:scan_interval]}</scanInterval>
      <autoDetect>true</autoDetect>
    </StorageDocument>
    XML

    existing_storage = get_storage()

    begin
      if existing_storage == false then
        # There is no storage with this name
        self.rest_post '/API/storage/', storage_document
      else
        # There is an existing storage with this name but it has the wrong metadata or properties
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
    end

    # Bit of a hack but if we are ensuring this is absent don't check the metadata
    if @resource[:ensure] == :absent then
      return storage['id']
    end

    # A storage with the correct name exists need to check it has the correct metadata and properties
    tests = [storage['scanInterval'] == @resource[:scan_interval]]
    if tests.all? then
      return storage['id']
    else
      return false
    end
  end

  def destroy
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
