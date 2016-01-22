# see README.md
class vidispine::params {

  $installer_dir                     = '/opt/installers'
  $glassfish_user                    = 'vidispine'
  $glassfish_uid                     = 2000
  $glassfish_group                   = 'vidispine'
  $glassfish_gid                     = 2000
  $glassfish_user_homedir            = '/home/vidispine'
  $glassfish_parent_dir              = '/opt'
  $glassfish_tmp_dir                 = '/tmp'
  $glassfish_install_dir             = 'glassfish3'
  $glassfish_das_portbase            = '4800'
  $glassfish_asadmin_user            = 'admin'
  $glassfish_asadmin_password        = 'adminadmin'
  $glassfish_asadmin_master_password = 'changeit'
  $glassfish_asadmin_jms_password    = 'vidispine'
  $glassfish_asadmin_passfile        = '/home/vidispine/asadmin.pass'
  $glassfish_imq_jvm_args            = '-Xms512m -Xmx512m -Xss228k'
  $glassfish_imq_maxbytespermsg      = '-1'
  $glassfish_domain_name             = 'vidispine-domain'
  $glassfish_jvmoptions_xmx          = '1024m'
  $glassfish_jvmoptions_xms          = '256m'
  $glassfish_jvmoptions_maxpermsize  = '512m'
  $glassfish_jvmoptions_permsize     = '512m'
  $glassfish_http_port               = '8080'
  $vidispine_admin_password          = 'admin'
  $vidispine_http_pool_size          = '50'
  $vidispine_http_pool_timeout       = '900'
  $vidispine_noauth_pool_size        = '50'
  $vidispine_noauth_pool_timeout     = '900'
  $vidispine_solr_pool_size          = '50'
  $postgresql_host                   = 'localhost'
  $postgresql_port                   = '5432'
  $postgresql_user                   = 'vidispine'
  $postgresql_password               = 'vidispine'
  $postgresql_database               = 'vidispinedb'
  $postgresql_imq_user               = 'openmq'
  $postgresql_imq_password           = 'openmq'
  $postgresql_imq_database           = 'openmqdb'
  $installer_database_run_migration  = true
  $solrcloud_enable                  = false
  $solr_collection_name              = 'vidispine'   # this is only used with an external solr config

  case $::operatingsystem {
    'Ubuntu': {
      case $::lsbdistcodename {
        'trusty': {
          $postgresql_version = '9.3'
        }
        default: {
          fail("Unsupported OS version ${::lsbdistcodename}, module ${module_name}")
        }
      }
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name}")
    }
  }
}
