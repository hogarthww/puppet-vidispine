class vidispine::glassfish::install {

  # add glassfish daemon account primary group
  if !defined(Group[$vidispine::glassfish_group]) {
    group { $vidispine::glassfish_group:
      ensure => 'present',
      gid    => $vidispine::glassfish_gid
    }
  }

  # add glassfish daemon account
  if !defined(User[$vidispine::glassfish_user]) {
    user { $vidispine::glassfish_user:
      ensure     => 'present',
      managehome => true,
      home       => $vidispine::glassfish_user_homedir,
      uid        => $vidispine::glassfish_uid,
      gid        => $vidispine::glassfish_group,
      require    => Group[$vidispine::glassfish_group]
    }
  }

  # install glassfish
  class {'::glassfish':
    parent_dir              => $vidispine::glassfish_parent_dir,
    tmp_dir                 => $vidispine::glassfish_tmp_dir,
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
    require                 => User[$vidispine::glassfish_user],
  }
  contain '::glassfish'

  # set glassfish JAVA_HOME
  ini_setting { 'as-java' :
    ensure            => present,
    key_val_separator => '=',
    section           => '',
    path              => "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/glassfish/config/asenv.conf",
    setting           => 'AS_JAVA',
    value             => "\"${::vidispine::java_home}\"",
    require           => Class['::glassfish::install'],
  }

}

