# see README.md
class vidispine::params {

  $glassfish_java_vendor  = 'oracle',
  $glassfish_java_package = 'j2sdk1.7',
  $glassfish_java_version = '1.7.0+update67',
  $glassfish_user         = 'vidispine',
  $glassfish_uid          = 2000,
  $glassfish_group        = 'vidispine',
  $glassfish_gid          = 2000,

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
