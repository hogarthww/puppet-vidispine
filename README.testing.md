# Testing this module

This module includes a number of unit tests which should be run after every change and should be
confirmed to be passing before every merge.

New functionality should include a corresponding test.

As the tests were retrofitted onto an existing codebase, the coverage is low, and currently limited
to the custom types and providers under `lib/puppet/` as well as a very basic "does it compile" test
of the manifests.

Consult the Wiki documentation for details on how to set up your development environment for working
on Puppet modules, Ruby, and rspec-puppet, and to put the below into context.

## Learning more

This document covers some basic concepts around Puppet module testing but tries to be specific and
relevant to this module itself rather than be a complete general guide to rspec. Please do read the
[rspec-puppet tutorial](http://rspec-puppet.com/tutorial/) to get some background, and take a look
at some of these high quality modules on the Forge which have fantastic rspec tests which you can
use as a model:

* [puppetlabs-aws](https://github.com/puppetlabs/puppetlabs-aws/)
* [puppetlabs-postgresql](https://github.com/puppetlabs/puppetlabs-postgresql)
* [bashtoni-varnish](https://github.com/BashtonLtd/puppet-varnish)

## Install Ruby Gems

Use bundler to install the Gems required by this module:

```
$ bundle install
```

## Running the tests

### Running the rspec unit tests

To run the unit tests:

```
$ bundle exec rake spec
```

This will download all dependent modules and run the spec tests. To re-run the tests and skip the
step of downloading the modules:

```
$ bundle exec rake spec_standalone
```

### Syntax checking

Syntax-check all Puppet manifests in one command:

```
$ bundle exec rake syntax
```

### Linting

[puppet-lint](http://puppet-lint.com/) will check that your manifests conform to the Puppet style
guide:

```
$ bundle exec rake lint
```

# Working with tests

## Where to find everything

#### `spec/spec_helper.rb`
The spec_helper sets up the rspec environment at runtime, loads and configures libraries and tools.

#### `spec/unit/puppet/provider/`
Rspec tests for the providers in `lib/puppet/provider/`.

#### `spec/classes/`
Rspec tests for the Puppet classes in `manifests/`.

#### `spec/fixtures/`
Fixtures are all the items required to provide a consistent and complete test environment.

#### `.fixtures.yml`
Where fixtures are external to this module (i.e.: other Puppet modules), they are listed here along
with the URL that they can be found at.

#### `spec/fixtures/modules/`
Puppet modules which this module depends on are downloaded into this directory before tests are run.

#### `spec/fixtures/vcr_cassettes`
Pre-recorded HTTP interactions between the module and Vidispine, encoded as YAML documents.
See below section - Webmock and VCR.


## Webmock and VCR

When testing code that interacts with an external HTTP service, in this case Vidispine's REST API,
it is important that the state of that service is consistent between tests. The overhead of setting
up an instance of Vidispine is fairly large, as would be the additional overhead of resetting its
state between each test run.

Therefore it is useful to provide a fake - pre-recorded HTTP interactions that can be played back
into the test run.

This is accomplished by the use of two Ruby libraries, Webmock and VCR.

[Webmock](https://github.com/bblimke/webmock) is a Ruby library which hooks into the other Ruby
libraries that provide the HTTP client API, intercepts the requests and diverts them to its own
routines. Those routines are configured as part of the test to respond in a certain way.

Instead of laboriously programming Webmock for each request and response interaction, we use the
[VCR](http://www.relishapp.com/vcr/vcr/docs) library. The first time the test is run, it is run
against a real instance of Vidispine. Webmock and VCR intercept the request and response, and record the
headers and body of each transaction in the YAML file (the cassette). The next time the test is run,
the cassette is played back.

This entire pattern is directly lifted from 
[Puppetlabs' module for managing AWS](https://github.com/puppetlabs/puppetlabs-aws).

## Structure of tests

Please refer to the comments in the following tests which have been heavily annotated to provide
in-context documentation:

* `spec/unit/puppet/provider/vidispine_system_field/vidispine_system_field_spec.rb`


