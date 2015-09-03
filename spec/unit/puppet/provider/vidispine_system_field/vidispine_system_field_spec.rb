# spec_helper is required by each test to set up the testing environment.
require 'spec_helper'

# Be explicit about the class (that is, Ruby class) that we expect this instance of the vidispine_system_field
# provider to be. Puppet's APIs will return an object of type Class here, representing the class of the
# provider object.
provider_class = Puppet::Type.type(:vidispine_system_field).provider(:vidispine_system_field)

# Tell rspec that what follows is a description of this class and its desired behaviour.
describe provider_class do

  # Give this test a name
  let(:name) { 'rspec vidispine_system_field test' }

  # Instantiate a Puppet resource, a vidispine_system_field with some valid parameters.
  # This is equivalent to declaring the following in Puppet DSL:
  #   vidispine_system_field {'rspec_system_field':
  #     value => '3ed0cc7c714f530fc2919d369335a1d280fd9686',
  #      ... etc ...
  #   }
  let(:resource) { Puppet::Type.type(:vidispine_system_field).new(
      :key        => 'rspec_system_field',
      :value      => '3ed0cc7c714f530fc2919d369335a1d280fd9686',
      :vshostname => 'localhost',
      :vsport     => '8080',
      :vsuser     => 'admin',
      :vspass     => 'admin'
      )}

  # Each resource has a type and a provider. Just now we generated a new resource using the Type API.
  # The provider is what we're testing, so we need to obtain the provider object from it.
  let(:provider) { resource.provider }

  # I am actually not sure what this is for or whether or not it's needed, but it was present in the
  # examples I copied. Apologies for the cargo cult engineering here :)
  let(:instance) { provider.class.instances.first }

  # The it .. do .. end blocks are named assertions about the behaviour of the thing under test.
  # Each of these blocks are mini programs that interact with the provider object in a specific
  # way and set expectations about the outcome of that interaction.
  #
  # If those expectations are not met, the test fails.

  it "should be an instance of Puppet::Type::Vidispine_system_field::ProviderVidispine_system_field" do
    # Here we get a bit of an insight into how Puppet uses Ruby's dynamic typing system to generate Ruby
    # classes for each of the Puppet types and providers that are defined within a module.
    
    expect(provider).to be_an_instance_of Puppet::Type::Vidispine_system_field::ProviderVidispine_system_field
  end

  # Providers must implement, at the minimum, an exists? method, a create method, and a destroy method.

  # We are describing the behaviour we want from the exists? method.
  describe 'exists?' do
    
    # If this vidispine_system_field didn't exist in the Vidispine instance, we'd want the provider
    # to return false here.
    it 'should correctly report non-existent system fields' do

      # We know that the provider will call out to Vidispine via HTTP to query the system fields
      # and parse the result to determine whether or not this specific field is there. So, we load up
      # a cassette which replays this interaction sending back a list of system fields that doesn't
      # include this one.
      VCR.use_cassette('vidispine_system_field-exists-false') do

        # Here is where we actually call the method we're testing: provider.exists?.
        # expect().to be_falsy is an rspec construct which asserts that the value returned must be
        # a boolean false, or something like it (such as the string 'false', or a 0).
        expect(provider.exists?).to be_falsy
      end
    end

    # This is the same test with the opposite result expected.
    it 'should correctly find existing system fields' do
      VCR.use_cassette('vidispine_system_field-exists-true') do
        expect(provider.exists?).to be_truthy
      end
    end
  end

  # The create and destroy tests are similarly simple, and we expect them to return a truthy value
  # indicating that they did their job successfully.
  #
  # Please do read the VCR cassette files themselves to see the HTTP interaction that is played
  # back as they are designed to be human readable (and editable).
  describe 'create' do
    it 'should create a system field' do
      VCR.use_cassette('vidispine_system_field-create') do
        expect(provider.create).to be_truthy
      end
    end
  end

  describe 'destroy' do
    it 'should delete a system field' do
      VCR.use_cassette('vidispine_system_field-destroy') do
        expect(provider.destroy).to be_truthy
      end
    end
  end


  # A slightly more complex test written to expose bug TP-526
  describe 'update existing field' do
    it 'should update the value of an existing field' do
      VCR.use_cassette('vidispine_system_field-update') do
        expect(provider.exists?).to be_falsy
        expect(provider.create).to be_truthy
        expect(provider.exists?).to be_truthy
      end
    end
  end
end

