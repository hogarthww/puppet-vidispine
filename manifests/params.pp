# see README.md
class vidispine::params {

  $service_ensure  = 'running'
  $service_enable  = true
  $package_ensure  = 'present'

  case $::osfamily {
    'debian': {

      # do something Ubuntu specific
      $package_name = "${::vidispine}-deb"

    }

    'redhat': {

      # do something RHEL specific
      $package_name = "${::vidispine}-rhel"

    }

    default: {

      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name}")

    }
  }
}
