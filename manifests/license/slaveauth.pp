define vidispine::license::slaveauth (
  $ensure               = 'present',
  $identifier           = $title,
  $master_node_address,
  $validate             = true,
  $validation_timeout   = 60,
) {

  validate_array($master_node_address)
  validate_bool($validate)
  validate_integer($validation_timeout)

  include '::vidispine::license'

  $slaveauth_license_path = "${::vidispine::license::path}/slaveAuth.lic"

  file { $slaveauth_license_path :
    ensure  => $ensure,
    content => template('vidispine/slaveAuth.lic.erb'),
    owner   => $::vidispine::license::owner,
    group   => $::vidispine::license::group,
    mode    => $::vidispine::license::mode,
    notify  => Vidispine_license_validation[$title],
  }

  # slaveAuth licenses are mutually exclusive with master licenses
  # we also want to remove the default license file
  vidispine::license::master { 'default':
    ensure   => absent,
    validate => false,
  }

  if ($validate) {
    vidispine_license_validation { $title :
      timeout    => $validation_timeout,
      vshostname => $::vidispine::glassfish_das_host,
      vsport     => $::vidispine::glassfish_http_port,
      vsuser     => $::vidispine::vidispine_admin_user,
      vspass     => $::vidispine::vidispine_admin_password,
      require    => [
        File[$slaveauth_license_path],
        Vidispine::License::Master['default'],
      ],
    }
  }

}

