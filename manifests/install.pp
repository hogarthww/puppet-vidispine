# see README.md
class vidispine::install {

  if !defined(Apt::Source['hogarthww']) {
    apt::source { 'hogarthww':
      comment     => 'The hogarth worldwide apt repo',
      location    => 'http://apt.hogarthww.prv/hogarthww/ubuntu/',
      release     => $lsbdistcodename,
      repos       => 'main',
      include_src => false,
      include_deb => true,
    }
  }

  package {"${zonza_vidispine::glassfish_java_vendor}-${zonza_vidispine::glassfish_java_package}":
    ensure  => $zonza_vidispine::glassfish_java_version,
    require => Apt::Source['hogarthww'],
  }

  # may have already been created by zonza_nfs on the same machine
  if !defined(Group[$zonza_vidispine::glassfish_group]) {
    group { $zonza_vidispine::glassfish_group:
      ensure => 'present',
      gid    => $zonza_vidispine::glassfish_gid
    }
  }

  # may have already been created by zonza_nfs on the same machine
  if !defined(User[$zonza_vidispine::glassfish_user]) {
    user { $zonza_vidispine::glassfish_user:
      ensure     => 'present',
      managehome => true,
      home       => $zonza_vidispine::glassfish_user_homedir,
      comment    => 'Glassfish user account',
      uid        => $zonza_vidispine::glassfish_uid,
      gid        => $zonza_vidispine::glassfish_group,
      require    => Group[$zonza_vidispine::glassfish_group]
    }
  }


}
