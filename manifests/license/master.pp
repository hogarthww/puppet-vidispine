define vidispine::license::master (
  $ensure             = 'present',
  $content            = '',
  $validate           = true,
  $validation_timeout = 60,
) {

  include '::vidispine::license'

  $master_license_path = "${::vidispine::license::path}/License.lic"

  if ($ensure == 'present') {
    validate_bool($validate)
    validate_integer($validation_timeout)

    if ($content == '') {
      fail("content of license can't be empty")
    }

    if ($validate) {
      vidispine_license_validation { $title :
        timeout    => $validation_timeout,
        vshostname => $::vidispine::glassfish_das_host,
        vsport     => $::vidispine::glassfish_http_port,
        vsuser     => $::vidispine::vidispine_admin_user,
        vspass     => $::vidispine::vidispine_admin_password,
        require    => File[$master_license_path],
        subscribe  => File[$master_license_path],
      }
    }
  }

  file { $master_license_path :
    ensure  => $ensure,
    content => $content,
    owner   => $::vidispine::license::owner,
    group   => $::vidispine::license::group,
    mode    => $::vidispine::license::mode,
  }

}

