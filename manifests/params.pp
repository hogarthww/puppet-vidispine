# see README.md
class vidispine::params {

  $glassfish_java_vendor             = 'oracle'
  $glassfish_java_package            = 'j2sdk1.7'
  $glassfish_java_version            = '1.7.0+update67'
  $glassfish_user                    = 'vidispine'
  $glassfish_uid                     = 2000
  $glassfish_group                   = 'vidispine'
  $glassfish_gid                     = 2000
  $glassfish_user_homedir            = '/home/vidispine'
  $glassfish_parent_dir              = '/opt'
  $glassfish_install_dir             = 'glassfish3'
  $glassfish_version                 = '3.1.2.2'
  $glassfish_das_portbase            = '4800'
  $glassfish_asadmin_user            = 'admin'
  $glassfish_asadmin_password        = 'adminadmin'
  $glassfish_asadmin_master_password = 'changeit'
  $glassfish_asadmin_jms_password    = 'vidispine'
  $glassfish_asadmin_passfile        = '/home/vidispine/asadmin.pass'
  $glassfish_imq_jvm_args            = '-Xms512m -Xmx512m -Xss228k'
  $glassfish_imq_maxbytespermsg      = '-1'
  $glassfish_domain_name             = 'vidispine-domain'
  $glassfish_das_host                = 'localhost'
  $glassfish_cluster_enable          = false
  $glassfish_cluster_name            = 'vidispine-cluster'
  $glassfish_jvmoptions_xmx          = '1024m'
  $glassfish_jvmoptions_xms          = '256m'
  $glassfish_jvmoptions_maxpermsize  = '512m'
  $glassfish_http_port               = '8080'
  $vidispine_version                 = '4.2.3'
  $vidispine_admin_user              = 'admin'
  $vidispine_admin_password          = 'admin'
  $vidispine_slave_license           = true
  $vidispine_slave_license_master    = 'http://10.9.1.19:8080/' # 'http://vidi1-devops-licensing.hogarthww.prv:8080/'
  $vidispine_slave_license_id        = 'hwwdevslaveidentifier'
  $postgresql_version                = '9.1'
  $postgresql_host                   = 'localhost'
  $postgresql_port                   = '5432'
  $postgresql_user                   = 'vidispine'
  $postgresql_password               = 'vidispine'
  $postgresql_database               = 'vidispinedb'

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
