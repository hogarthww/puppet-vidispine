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

  $glassfish_java_vendor  = hiera('glassfish_java_vendor',  $vidispine::params::glassfish_java_vendor),
  $glassfish_java_package = hiera('glassfish_java_package', $vidispine::params::glassfish_java_package),
  $glassfish_java_version = hiera('glassfish_java_version', $vidispine::params::glassfish_java_version),
  $glassfish_user         = hiera('glassfish_user',         $vidispine::params::glassfish_user),
  $glassfish_uid          = hiera('glassfish_uid',          $vidispine::params::glassfish_uid),
  $glassfish_group        = hiera('glassfish_group',        $vidispine::params::glassfish_group),
  $glassfish_gid          = hiera('glassfish_gid',          $vidispine::params::glassfish_gid),

) inherits vidispine::params {

  anchor { 'vidispine::begin' : } ->
    class  { 'vidispine::install' : } ->
    class  { 'vidispine::config'  : } ~>
    class  { 'vidispine::service' : } ->
  anchor { 'vidispine::end'   : }

}
