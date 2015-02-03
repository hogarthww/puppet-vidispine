# see README.md
class vidispine::params {

  $installer_dir                     = '/opt/installers'
  $glassfish_java_vendor             = 'oracle'
  $glassfish_java_package            = 'j2sdk1.7'
  $glassfish_java_version            = '1.7.0+update67'
  $glassfish_java_apt_repo           = {
                                         name     => 'hogarthww',
                                         location => 'http://apt.hogarthww.prv/hogarthww/ubuntu/',
                                         comment  => 'The hogarth worldwide apt repo',
                                       }
  $glassfish_user                    = 'vidispine'
  $glassfish_uid                     = 2000
  $glassfish_group                   = 'vidispine'
  $glassfish_gid                     = 2000
  $glassfish_user_homedir            = '/home/vidispine'
  $glassfish_parent_dir              = '/opt'
  $glassfish_install_dir             = 'glassfish3'
  $glassfish_version                 = '3.1.2.2'
  $glassfish_archive_location        = 'http://download.java.net/glassfish/' # this is not currently honoured
  $glassfish_das_portbase            = '4800'
  $glassfish_asadmin_user            = 'admin'
  $glassfish_asadmin_password        = 'adminadmin'
  $glassfish_asadmin_master_password = 'changeit'
  $glassfish_asadmin_jms_password    = 'vidispine'
  $glassfish_asadmin_passfile        = '/home/vidispine/asadmin.pass'
  $glassfish_imq_jvm_args            = '-Xms512m -Xmx512m -Xss228k'
  $glassfish_imq_maxbytespermsg      = '-1'
  $glassfish_imq_cluster_enable      = false
  $glassfish_imq_broker_list         = undef
  $glassfish_domain_name             = 'vidispine-domain'
  $glassfish_das_host                = 'localhost'
  $glassfish_cluster_enable          = false
  $glassfish_cluster_name            = 'vidispine-cluster'
  $glassfish_node_name               = $::hostname
  $glassfish_instance_name           = "${::hostname}-instance"
  $glassfish_jvmoptions_xmx          = '1024m'
  $glassfish_jvmoptions_xms          = '256m'
  $glassfish_jvmoptions_maxpermsize  = '512m'
  $glassfish_http_port               = '8080'
  $vidispine_version                 = '4.2.3'
  $vidispine_archive_location        = 'http://apt.hogarthww.prv/files/vidispine/'
  $vidispine_admin_user              = 'admin'
  $vidispine_admin_password          = 'admin'
  $vidispine_slave_license           = false
  $vidispine_slave_license_master    = 'http://master.com:8080/'
  $vidispine_slave_license_id        = 'slaveidentifier'
  $vidispine_cluster_enable          = false
  $vidispine_http_pool_size          = '50'
  $vidispine_http_pool_timeout       = '900'
  $vidispine_noauth_pool_size        = '50'
  $vidispine_noauth_pool_timeout     = '900'
  $vidispine_solr_pool_size          = '50'
  $vidispine_jdbc_max_size           = '32'
  $postgresql_version                = '9.1'
  $postgresql_host                   = 'localhost'
  $postgresql_port                   = '5432'
  $postgresql_user                   = 'vidispine'
  $postgresql_password               = 'vidispine'
  $postgresql_database               = 'vidispinedb'
  $postgresql_imq_user               = 'openmq'
  $postgresql_imq_password           = 'openmq'
  $postgresql_imq_database           = 'openmqdb'
  $solr_collection_name              = 'collection1'   # this is only used with an external solr config

  case $::osfamily {
    'debian': {
      # do something Ubuntu specific

    }

    'redhat': {
      # do something RHEL specific

    }

    default: {

      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name}")

    }
  }
}
