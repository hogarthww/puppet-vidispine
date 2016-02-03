# Vidispine module for Puppet

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with vidispine](#setup)
    * [What vidispine affects](#what-vidispine-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with vidispine](#beginning-with-vidispine)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The Vidispine module manages the installation and configuration of
[Vidispine](http://www.vidispine.com/).

## License

This Puppet module is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License version 2 as published by the Free
Software Foundation.

This Puppet module is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this
Puppet module. If not, see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

## Module Description

Vidispine is a content management platform providing cataloguing, indexing,
searching, and transcoding of media assets via REST APIs.

The module supports installation of an instance of Vidispine in a Glassfish 
container, and configuration of the instance.

Because Vidispine stores its configuration in its database instead of in
config files, all configuration must be performed via the API. The module
defines custom types and providers representing configuration entities within
Vidispine, so that these configuration items can be managed as Puppet resources.

## Setup

### What vidispine affects

* Installs Oracle Glassfish 3 under `/opt/glassfish3`
* Downloads, unpacks, and runs the Vidispine installer under `/opt/installers`
* Creates a user account for Vidispine to run under
* Installs an init script to allow Vidispine to be controlled as a service
* Configures Vidispine via the configuration API

### Setup Requirements

This module depends on the following other modules:
* [hww-glassfish](https://github.com/hogarthww/puppet-glassfish) - this is
  a fork of [fatmcgav-glassfish](https://github.com/fatmcgav/puppet-glassfish)
* [nanliu-staging](https://github.com/nanliu/puppet-staging)
* [puppetlabs-stdlib](https://github.com/puppetlabs/puppetlabs-stdlib) version 4.10.0 or higher
* [puppetlabs-apt](https://github.com/puppetlabs/puppetlabs-apt) version 1.8.0
* [puppetlabs-inifile](https://github.com/puppetlabs/puppetlabs-inifile)

Pluginsync must be enabled.

### Install Vidispine

Instantiating the `vidispine` class should result in an installation. The list of
parameters to the `vidispine` class is very long, although most should not need
to deviate from defaults.

### Configure Vidispine

Configure a storage backend:

```
vidispine::storage {'storage1':
  ensure     => present,
  vsurl      => 'http://localhost:8080'
  vsuser     => 'admin',
  vspass     => 'admin',
}

vidispine::storage_method {"auto-http://${::fqdn}:8080/storage1/":
  ensure     => present,
  storageuri => "http://${::fqdn}:8080/storage1/",
  vsurl      => 'http://localhost:8080'
  vsuser     => 'admin',
  vspass     => 'admin',
  location   => "storage1",
  read       => 'true',
  write      => 'true',
  browse     => 'true',
  type       => 'AUTO',
  require    => Vidispine::Storage['storage1'],
}
```

Connect a transcoder:

```
vidispine::transcoder {"http://transcoder1:8080/":
  ensure     => present,
  vsurl      => 'http://localhost:8080'
  vsuser     => 'admin',
  vspass     => 'admin',
  trans_addr => 'http://transcoder1',
  trans_port => 8080,
}
```

## Reference

### Types

The module contains custom types which are backed by a provider that communicates
with Vidispine through its REST API. Each custom type is wrapped in a defined type,
i.e. `vidispine_storage` has a wrapper deftype `vidispine::storage`.

As is standard for any Puppet module:
* Custom types can be found under `lib/puppet/type`
* Defined types can be found in `manifests`
* Providers can be found under `lib/puppet/provider`

Parameters shared by all types:
* `vsurl`: The HTTP URL of the Vidispine API
* `vsuser`: A username with admin privileges on the Vidispine instance (always 'admin')
* `vspass`: The password for the admin account

There is a potential enhancement here, to set these parameters centrally.

Each type is ensurable (`ensure => present` or `ensure => absent` can be set).

For more a more in-depth explanation of what each of these resources will affect within
Vidispine itself, please refer to the corresponding section of the Vidispine
[API documentation](http://apidoc.vidispine.com/latest/).

#### `vidispine_storage`, `vidispine::storage`

Define a storage backend.

`name`: The name of the storage.

`scan_interval`: The scanInterval of the storage.

Vidispine API: http://apidoc.vidispine.com/latest/storage/storage.html

#### `vidispine_storage_method`, `vidispine::storage_method`

Define methods by which to reach an existing storage.

`storageuri`: The URI at which the storage can be reached (see API doc for supported protocols)

`location`: The name of the storage that this method applies to (this should match
the name of the corresponding `vidispine::storage` resource)

`read`, `write`, `browse`: boolean flags - refer to API doc.

`type`: The storage type - refer to API doc.

Vidispine API: http://apidoc.vidispine.com/latest/storage/storage.html

#### `vidispine_system_field`, `vidispine::system_field`

System fields are simple key-value pairs that configure Vidispine. Note that you can 
set any system field; Vidispine will not reject values that it doesn't know about, but
only values that are known will have an effect on the application.

`name`: The name of the system field

`value`: The value of the system field

Vidispine API: http://apidoc.vidispine.com/latest/system/property.html

#### `vidispine_transcoder`, `vidispine::transcoder`

`url`: The HTTP URL of the transcoder

#### `vidispine_thumbnails`, `vidispine::thumbnails`

Set up a thumbnail resource. The name of the resource should be the path to the thumbnails.

`name`: The path to the thumbnails as a URL, e.g. `file:///opt/vidispine/thumbnails`

Please see the Vidispine 
[API documentation](http://apidoc.vidispine.com/latest/system/thumbnails.html) for details.

## Limitations

* Custom types do not implement prefetching, making Puppet runs very slow and very
  'chatty' with the Vidispine API
* There is not yet a way to centrally specify `vsurl`, `vsuser`, `vspass`
* Clustering is not supported.
* Documentation is patchy
* Test coverage is not complete

## Development

Pull requests are welcome. Additional functionality should come with additional test coverage.
Pull requests which cause tests to fail are unlikely to be accepted.

### Contributors
 * Adam Scarborough
 * Chris D'Cunha
 * Doug Neal
 * Matthew Power
 * Richard Davies
 * Rob Ryan
 * Samuel Fekete
 * Thomas O'Donnell

