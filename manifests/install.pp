# see README.md
class vidispine::install {

  # add hogarthww apt repo if we don't have it
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

  # install java package glassfish will use
  package {"${zonza_vidispine::glassfish_java_vendor}-${zonza_vidispine::glassfish_java_package}":
    ensure  => $zonza_vidispine::glassfish_java_version,
    require => Apt::Source['hogarthww'],
  }

  # add glassfish daemon account primary group
  # may have already been created by zonza_nfs on the same machine
  if !defined(Group[$zonza_vidispine::glassfish_group]) {
    group { $zonza_vidispine::glassfish_group:
      ensure => 'present',
      gid    => $zonza_vidispine::glassfish_gid
    }
  }

  # add glassfish daemon account
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

  # install glassfish
  # requires access to http://download.java.net/
  class {'glassfish':
    parent_dir              => $zonza_vidispine::glassfish_parent_dir,
    install_dir             => $zonza_vidispine::glassfish_install_dir,
    version                 => $zonza_vidispine::glassfish_version,
    create_domain           => false,
    create_service          => false,
    manage_accounts         => false,
    manage_java             => false,
    user                    => $zonza_vidispine::glassfish_user,
    group                   => $zonza_vidispine::glassfish_group,
    portbase                => $zonza_vidispine::glassfish_das_portbase,
    asadmin_user            => $zonza_vidispine::glassfish_asadmin_user,
    asadmin_password        => $zonza_vidispine::glassfish_asadmin_password,
    asadmin_master_password => $zonza_vidispine::glassfish_asadmin_master_password,
    asadmin_jms_password    => $zonza_vidispine::glassfish_asadmin_jms_password,
    asadmin_passfile        => $zonza_vidispine::glassfish_asadmin_passfile,
    require                 => [
      Package["${zonza_vidispine::glassfish_java_vendor}-${zonza_vidispine::glassfish_java_package}"],
      User[$zonza_vidispine::glassfish_user],
    ],
  }
  contain 'glassfish'

}
