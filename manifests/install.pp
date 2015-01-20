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
  package {"${vidispine::glassfish_java_vendor}-${vidispine::glassfish_java_package}":
    ensure  => $vidispine::glassfish_java_version,
    require => Apt::Source['hogarthww'],
  }

  # add glassfish daemon account primary group
  # may have already been created by zonza_nfs on the same machine
  if !defined(Group[$vidispine::glassfish_group]) {
    group { $vidispine::glassfish_group:
      ensure => 'present',
      gid    => $vidispine::glassfish_gid
    }
  }

  # add glassfish daemon account
  # may have already been created by zonza_nfs on the same machine
  if !defined(User[$vidispine::glassfish_user]) {
    user { $vidispine::glassfish_user:
      ensure     => 'present',
      managehome => true,
      home       => $vidispine::glassfish_user_homedir,
      comment    => 'Glassfish user account',
      uid        => $vidispine::glassfish_uid,
      gid        => $vidispine::glassfish_group,
      require    => Group[$vidispine::glassfish_group]
    }
  }

  # install glassfish
  # requires access to http://download.java.net/
  class {'glassfish':
    parent_dir              => $vidispine::glassfish_parent_dir,
    install_dir             => $vidispine::glassfish_install_dir,
    version                 => $vidispine::glassfish_version,
    create_domain           => false,
    create_service          => false,
    manage_accounts         => false,
    manage_java             => false,
    user                    => $vidispine::glassfish_user,
    group                   => $vidispine::glassfish_group,
    portbase                => $vidispine::glassfish_das_portbase,
    asadmin_user            => $vidispine::glassfish_asadmin_user,
    asadmin_password        => $vidispine::glassfish_asadmin_password,
    asadmin_master_password => $vidispine::glassfish_asadmin_master_password,
    asadmin_jms_password    => $vidispine::glassfish_asadmin_jms_password,
    asadmin_passfile        => $vidispine::glassfish_asadmin_passfile,
    require                 => [
      Package["${vidispine::glassfish_java_vendor}-${vidispine::glassfish_java_package}"],
      User[$vidispine::glassfish_user],
    ],
  }
  contain 'glassfish'

  ini_setting { 'as-java' :
    ensure            => present,
    key_val_separator => '=',
    section           => '',
    path              => "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/glassfish/config/asenv.conf",
    setting           => 'AS_JAVA',
    value             => "\"/usr/lib/jvm/${vidispine::glassfish_java_package}-${vidispine::glassfish_java_vendor}/jre\"",
    require           => Class['glassfish'],
  }

  ini_setting { 'imq-java-home' :
    ensure            => present,
    key_val_separator => '=',
    section           => '',
    path              => "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/mq/etc/imqenv.conf",
    setting           => 'IMQ_DEFAULT_JAVAHOME',
    value             => "\"/usr/lib/jvm/${vidispine::glassfish_java_package}-${vidispine::glassfish_java_vendor}/jre\"",
    require           => Class['glassfish'],
  }

  ini_setting { 'imq-jvm-args' :
    ensure            => present,
    key_val_separator => '=',
    section           => '',
    path              => "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/mq/bin/imqbrokerd",
    setting           => '_def_jvm_args',
    value             => $vidispine::glassfish_imq_jvm_args,
    require           => Class['glassfish'],
  }

}
