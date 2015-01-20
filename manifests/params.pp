# see README.md
class vidispine::params {

  $glassfish_java_vendor             = 'oracle',
  $glassfish_java_package            = 'j2sdk1.7',
  $glassfish_java_version            = '1.7.0+update67',
  $glassfish_user                    = 'vidispine',
  $glassfish_uid                     = 2000,
  $glassfish_group                   = 'vidispine',
  $glassfish_gid                     = 2000,
  $glassfish_user_homedir            = '/home/vidispine',
  $glassfish_parent_dir              = '/opt',
  $glassfish_install_dir             = 'glassfish3',
  $glassfish_version                 = '3.1.2.2',
  $glassfish_das_portbase            = '4800',
  $glassfish_asadmin_user            = 'admin',
  $glassfish_asadmin_password        = 'adminadmin',
  $glassfish_asadmin_master_password = 'changeit',
  $glassfish_asadmin_jms_password    = 'vidispine',
  $glassfish_asadmin_passfile        = '/home/vidispine/asadmin.pass',

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
