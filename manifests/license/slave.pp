define vidispine::license::slave (
  $ensure  = 'present',
  $content = '',
) {

  include '::vidispine::license'

  if ($ensure == 'present') {
    if ($content == '') {
      fail("content of license can't be empty")
    }
  }

  file { "${::vidispine::license::path}/Slave.lic":
    ensure  => $ensure,
    content => $content,
    owner   => $::vidispine::license::owner,
    group   => $::vidispine::license::group,
    mode    => $::vidispine::license::mode,
  }

}

