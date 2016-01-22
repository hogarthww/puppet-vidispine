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

  $java_home,
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
  $glassfish_domain_name             = $vidispine::params::glassfish_domain_name,
  $glassfish_jvmoptions_xmx          = $vidispine::params::glassfish_jvmoptions_xmx,
  $glassfish_jvmoptions_xms          = $vidispine::params::glassfish_jvmoptions_xms,
  $glassfish_jvmoptions_maxpermsize  = $vidispine::params::glassfish_jvmoptions_maxpermsize,
  $glassfish_jvmoptions_permsize     = $vidispine::params::glassfish_jvmoptions_permsize,
  $glassfish_http_port               = $vidispine::params::glassfish_http_port,
  $vidispine_version,
  $vidispine_archive_location,
  $vidispine_admin_password          = $vidispine::params::vidispine_admin_password,
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
  $installer_database_run_migration  = $vidispine::params::installer_database_run_migration,
  $solrcloud_enable                  = $vidispine::params::solrcloud_enable,
  $zookeeper_servers                 = [],
  $solr_collection_name              = $vidispine::params::solr_collection_name,

) inherits vidispine::params {

  # We may want to make this a parameter
  $glassfish_das_host = 'localhost'
  $api_url = "http://${glassfish_das_host}:${glassfish_http_port}"
  $glassfish_version = '3.1.2.2'

  $vidispine_admin_user = 'admin'

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
