# == Class: vidispine
#
# Full description of class vidispine here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'vidispine':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Hogarth WW, unless otherwise noted.
#
class vidispine (

  $service_ensure  = hiera('vidispine_service_ensure', $vidispine::params::service_ensure),
  $service_enable  = hiera('vidispine_service_enable,  $vidispine::params::service_enable),
  $package_ensure  = hiera('vidispine_package_ensure', $vidispine::params::package_ensure),
  $package_name    = hiera('vidispine_package_name',   $vidispine::params::package_name),

) inherits vidispine::params {

  anchor { 'vidispine::begin' : } ->
    class  { 'vidispine::install' : } ->
    class  { 'vidispine::config'  : } ~>
    class  { 'vidispine::service' : } ->
  anchor { 'vidispine::end'   : }

}
