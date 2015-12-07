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

  $installer_dir                     = $vidispine::params::installer_dir,
  $glassfish_user                    = $vidispine::params::glassfish_user,
  $glassfish_uid                     = $vidispine::params::glassfish_uid,
  $glassfish_group                   = $vidispine::params::glassfish_group,
  $glassfish_gid                     = $vidispine::params::glassfish_gid,
  $glassfish_user_homedir            = $vidispine::params::glassfish_user_homedir,
  $glassfish_parent_dir              = $vidispine::params::glassfish_parent_dir,
  $glassfish_tmp_dir                 = $vidispine::params::glassfish_tmp_dir,
  $glassfish_install_dir             = $vidispine::params::glassfish_install_dir,
  $glassfish_das_portbase            = $vidispine::params::glassfish_das_portbase,
  $glassfish_asadmin_user            = $vidispine::params::glassfish_asadmin_user,
  $glassfish_asadmin_password        = $vidispine::params::glassfish_asadmin_password,
  $glassfish_asadmin_master_password = $vidispine::params::glassfish_asadmin_master_password,
  $glassfish_asadmin_jms_password    = $vidispine::params::glassfish_asadmin_jms_password,
  $glassfish_asadmin_passfile        = $vidispine::params::glassfish_asadmin_passfile,
  $glassfish_imq_jvm_args            = $vidispine::params::glassfish_imq_jvm_args,
  $glassfish_imq_maxbytespermsg      = $vidispine::params::glassfish_imq_maxbytespermsg,
  $glassfish_imq_cluster_enable      = $vidispine::params::glassfish_imq_cluster_enable,
  $glassfish_imq_broker_list         = $vidispine::params::glassfish_imq_broker_list,
  $glassfish_domain_name             = $vidispine::params::glassfish_domain_name,
  $glassfish_das_host                = $vidispine::params::glassfish_das_host,
  $glassfish_cluster_enable          = $vidispine::params::glassfish_cluster_enable,
  $glassfish_cluster_name            = $vidispine::params::glassfish_cluster_name,
  $glassfish_node_name               = $vidispine::params::glassfish_node_name,
  $glassfish_instance_name           = $vidispine::params::glassfish_instance_name,
  $glassfish_jvmoptions_xmx          = $vidispine::params::glassfish_jvmoptions_xmx,
  $glassfish_jvmoptions_xms          = $vidispine::params::glassfish_jvmoptions_xms,
  $glassfish_jvmoptions_maxpermsize  = $vidispine::params::glassfish_jvmoptions_maxpermsize,
  $glassfish_jvmoptions_permsize     = $vidispine::params::glassfish_jvmoptions_permsize,
  $glassfish_http_port               = $vidispine::params::glassfish_http_port,
  $vidispine_version                 = $vidispine::params::vidispine_version,
  $vidispine_apphost                 = $vidispine::params::vidispine_apphost,
  $vidispine_archive_location        = $vidispine::params::vidispine_archive_location,
  $vidispine_admin_user              = $vidispine::params::vidispine_admin_user,
  $vidispine_admin_password          = $vidispine::params::vidispine_admin_password,
  $vidispine_slave_license           = $vidispine::params::vidispine_slave_license,
  $vidispine_slave_license_master    = $vidispine::params::vidispine_slave_license_master,
  $vidispine_slave_license_id        = $vidispine::params::vidispine_slave_license_id,
  $vidispine_cluster_enable          = $vidispine::params::vidispine_cluster_enable,
  $vidispine_http_pool_size          = $vidispine::params::vidispine_http_pool_size,
  $vidispine_http_pool_timeout       = $vidispine::params::vidispine_http_pool_timeout,
  $vidispine_noauth_pool_size        = $vidispine::params::vidispine_noauth_pool_size,
  $vidispine_noauth_pool_timeout     = $vidispine::params::vidispine_noauth_pool_timeout,
  $vidispine_solr_pool_size          = $vidispine::params::vidispine_solr_pool_size,
  $vidispine_jdbc_max_size           = undef,
  $vidispine_jdbc_max_wait_time      = undef,
  $postgresql_version                = $vidispine::params::postgresql_version,
  $postgresql_host                   = $vidispine::params::postgresql_host,
  $postgresql_port                   = $vidispine::params::postgresql_port,
  $postgresql_user                   = $vidispine::params::postgresql_user,
  $postgresql_password               = $vidispine::params::postgresql_password,
  $postgresql_database               = $vidispine::params::postgresql_database,
  $postgresql_imq_user               = $vidispine::params::postgresql_imq_user,
  $postgresql_imq_password           = $vidispine::params::postgresql_imq_password,
  $postgresql_imq_database           = $vidispine::params::postgresql_imq_database,
  $installer_database_run_migration  = $vidispine::params::installer_database_run_migration,
  $solrcloud_enable                  = $vidispine::params::solrcloud_enable,
  $zookeeper_servers                 = [],
  $solr_collection_name              = $vidispine::params::solr_collection_name,
  $newrelic_license_key              = $vidispine::params::newrelic_license_key,
  $newrelic_archive_location         = $vidispine::params::newrelic_archive_location,
  $newrelic_version                  = undef,

) inherits vidispine::params {

  # Vidispine is very perticular about the version of glassfish and java that
  # is installed. Set these based on the Vidispine version.
  case $vidispine_version {
    default: {
      $glassfish_java_vendor  = 'oracle'
      $glassfish_java_package = 'j2sdk1.7'
      $glassfish_java_version = '1.7.0+update67'
      $glassfish_version      = '3.1.2.2'
    }
  }

  # Need to take the array and change it into a comma seperated list for use
  # in the templates. The sort is there so that with the same data the string
  # is always the same.
  $zookeeper_servers_str = join(sort($zookeeper_servers), ',')

  class { '::vidispine::glassfish' : } ->
  class { '::vidispine::install' : } ->
  class { '::vidispine::config' : }

  contain '::vidispine::glassfish'
  contain '::vidispine::install'
  contain '::vidispine::config'

}
