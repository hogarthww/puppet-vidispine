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

  $glassfish_java_vendor             = hiera('glassfish_java_vendor',             $vidispine::params::glassfish_java_vendor),
  $glassfish_java_package            = hiera('glassfish_java_package',            $vidispine::params::glassfish_java_package),
  $glassfish_java_version            = hiera('glassfish_java_version',            $vidispine::params::glassfish_java_version),
  $glassfish_user                    = hiera('glassfish_user',                    $vidispine::params::glassfish_user),
  $glassfish_uid                     = hiera('glassfish_uid',                     $vidispine::params::glassfish_uid),
  $glassfish_group                   = hiera('glassfish_group',                   $vidispine::params::glassfish_group),
  $glassfish_gid                     = hiera('glassfish_gid',                     $vidispine::params::glassfish_gid),
  $glassfish_user_homedir            = hiera('glassfish_user_homedir',            $vidispine::params::glassfish_user_homedir),
  $glassfish_parent_dir              = hiera('glassfish_parent_dir',              $vidispine::params::glassfish_parent_dir),
  $glassfish_install_dir             = hiera('glassfish_install_dir',             $vidispine::params::glassfish_install_dir),
  $glassfish_version                 = hiera('glassfish_version',                 $vidispine::params::glassfish_version),
  $glassfish_das_portbase            = hiera('glassfish_das_portbase',            $vidispine::params::glassfish_das_portbase),
  $glassfish_asadmin_user            = hiera('glassfish_asadmin_user',            $vidispine::params::glassfish_asadmin_user),
  $glassfish_asadmin_password        = hiera('glassfish_asadmin_password',        $vidispine::params::glassfish_asadmin_password),
  $glassfish_asadmin_master_password = hiera('glassfish_asadmin_master_password', $vidispine::params::glassfish_asadmin_master_password),
  $glassfish_asadmin_jms_password    = hiera('glassfish_asadmin_jms_password',    $vidispine::params::glassfish_asadmin_jms_password),
  $glassfish_asadmin_passfile        = hiera('glassfish_asadmin_passfile',        $vidispine::params::glassfish_asadmin_passfile),
  $glassfish_imq_jvm_args            = hiera('glassfish_imq_jvm_args',            $vidispine::params::glassfish_imq_jvm_args),
  $glassfish_imq_maxbytespermsg      = hiera('glassfish_imq_maxbytespermsg',      $vidispine::params::glassfish_imq_maxbytespermsg),
  $glassfish_domain_name             = hiera('glassfish_domain_name',             $vidispine::params::glassfish_domain_name),
  $glassfish_das_host                = hiera('glassfish_das_host',                $vidispine::params::glassfish_das_host),
  $glassfish_cluster_enable          = hiera('glassfish_cluster_enable',          $vidispine::params::glassfish_cluster_enable),
  $glassfish_cluster_name            = hiera('glassfish_cluster_name',            $vidispine::params::glassfish_cluster_name),
  $glassfish_jvmoptions_xmx          = hiera('glassfish_jvmoptions_xmx',          $vidispine::params::glassfish_jvmoptions_xmx),
  $glassfish_jvmoptions_xms          = hiera('glassfish_jvmoptions_xms',          $vidispine::params::glassfish_jvmoptions_xms),
  $glassfish_jvmoptions_maxpermsize  = hiera('glassfish_jvmoptions_maxpermsize',  $vidispine::params::glassfish_jvmoptions_maxpermsize),
  $glassfish_http_port               = hiera('glassfish_http_port',               $vidispine::params::glassfish_http_port),
  $vidispine_version                 = hiera('vidispine_version',                 $vidispine::params::vidispine_version),

) inherits vidispine::params {

  anchor { 'vidispine::begin' : } ->
    class  { 'vidispine::install' : } ->
    class  { 'vidispine::config'  : } ~>
    class  { 'vidispine::service' : } ->
  anchor { 'vidispine::end'   : }

}
