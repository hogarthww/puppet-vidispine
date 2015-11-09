class vidispine::glassfish::domain::configure {
  
  # We set a bunch of Glassfish domain attributes here. They need to happen before the Vidispine installer
  # is exec'd. Specifically, if the http-listener-1.port is set too late, the installer will bomb out as
  # it won't be able to communicate to the Vidispine HTTP API.
  #
  Set {
    ensure       => present,
    dashost      => $vidispine::glassfish_das_host,
    portbase     => $vidispine::glassfish_das_portbase,
    asadminuser  => $vidispine::glassfish_asadmin_user,
    passwordfile => $vidispine::glassfish_asadmin_passfile,
    user         => $vidispine::glassfish_user,
   # require      => Glassfish::Create_domain[$vidispine::glassfish_domain_name],
   # notify       => Exec['vidispine-installer'],
  }

  # set default java-home if we are running the das
  set { 'default-config.java-config.java-home':
    value => "/usr/lib/jvm/${vidispine::glassfish_java_package}-${vidispine::glassfish_java_vendor}/jre",
  }

  # set server java-home if we are running the das
  set { 'server.java-config.java-home':
    value => "/usr/lib/jvm/${vidispine::glassfish_java_package}-${vidispine::glassfish_java_vendor}/jre",
  }

  # set server http-listener-1.port if we are running the das
  set { 'server-config.network-config.network-listeners.network-listener.http-listener-1.port':
    value => $vidispine::glassfish_http_port,
  }

  # set server system-property.HTTP_LISTENER_PORT.value if we are running the das
  set { 'default-config.system-property.HTTP_LISTENER_PORT.value':
    value => $vidispine::glassfish_http_port,
  }

  if ($vidispine::glassfish_cluster_enable) {
    # set cluster_name java-home if we are running the das and part of a cluster
    set { "${vidispine::glassfish_cluster_name}-config.java-config.java-home":
      value => "/usr/lib/jvm/${vidispine::glassfish_java_package}-${vidispine::glassfish_java_vendor}/jre",
    }
  }

  $jvmoption_target = 'server'

  ## These won't be needed anymore
  ##

  # set jvmoption requirements if we are running the das
  $jvmoption_reqs   = [
    #Ini_setting['as-java'],
    #Ini_setting['imq-java-home'],
    #File["${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/mq/bin/imqbrokerd"],
    #Ini_setting['imq-broker-maxbytespermsg'],
    Glassfish::Create_domain[$vidispine::glassfish_domain_name],
  ]

  # We don't want to have duplicate declarations if we are trying to set the
  # -Xmx jvm option to 512m.
  if $vidispine::glassfish_jvmoptions_xmx != '512m' {
    # remove default -Xmx jvm option for vidispine glassfish instance
    jvmoption {'-Xmx512m':
      ensure       => absent,
      target       => $jvmoption_target,
      portbase     => $vidispine::glassfish_admin_portbase,
      asadminuser  => $vidispine::glassfish_asadmin_user,
      passwordfile => $vidispine::glassfish_asadmin_passfile,
      user         => $vidispine::glassfish_user,
      require      => $jvmoption_reqs,
    }
  }

  # add -Xmx jvm option for vidispine glassfish instance
  jvmoption {"-Xmx${vidispine::glassfish_jvmoptions_xmx}":
    ensure       => present,
    target       => $jvmoption_target,
    portbase     => $vidispine::glassfish_admin_portbase,
    asadminuser  => $vidispine::glassfish_asadmin_user,
    passwordfile => $vidispine::glassfish_asadmin_passfile,
    user         => $vidispine::glassfish_user,
    require      => $jvmoption_reqs,
  }

  # add -Xms jvm option for vidispine glassfish instance
  jvmoption {"-Xms${vidispine::glassfish_jvmoptions_xms}":
    ensure       => present,
    target       => $jvmoption_target,
    portbase     => $vidispine::glassfish_admin_portbase,
    asadminuser  => $vidispine::glassfish_asadmin_user,
    passwordfile => $vidispine::glassfish_asadmin_passfile,
    user         => $vidispine::glassfish_user,
    require      => $jvmoption_reqs,
  }

  # We don't want to have duplicate declarations if we are trying to set the
  # -XX:PermSize to 64m.
  if $vidispine::glassfish_jvmoptions_permsize != '64m' {
  # remove -XX:PermSize=64m jvm option for vidispine glassfish instance
    jvmoption {'-XX:PermSize=64m':
      ensure       => absent,
      target       => $jvmoption_target,
      portbase     => $vidispine::glassfish_admin_portbase,
      asadminuser  => $vidispine::glassfish_asadmin_user,
      passwordfile => $vidispine::glassfish_asadmin_passfile,
      user         => $vidispine::glassfish_user,
      require      => $jvmoption_reqs,
    #  before       => Staging::Deploy["Vidispine_${vidispine::vidispine_version}_SoftwareInstaller.zip"],
    }

    # add -XX:PermSize jvm option for vidispine glassfish instance
    jvmoption {"-XX:PermSize=${vidispine::glassfish_jvmoptions_permsize}":
      ensure       => present,
      target       => $jvmoption_target,
      portbase     => $vidispine::glassfish_admin_portbase,
      asadminuser  => $vidispine::glassfish_asadmin_user,
      passwordfile => $vidispine::glassfish_asadmin_passfile,
      user         => $vidispine::glassfish_user,
      require      => $jvmoption_reqs,
    #  before       => Staging::Deploy["Vidispine_${vidispine::vidispine_version}_SoftwareInstaller.zip"],
    }
  }

  # We don't want to have duplicate declarations if we are trying to set the
  # -XX:MaxPermSize to 192m.
  if $vidispine::glassfish_jvmoptions_maxpermsize != '192m' {
  # remove -XX:MaxPermSize=192m jvm option for vidispine glassfish instance
    jvmoption {'-XX:MaxPermSize=192m':
      ensure       => absent,
      target       => $jvmoption_target,
      portbase     => $vidispine::glassfish_admin_portbase,
      asadminuser  => $vidispine::glassfish_asadmin_user,
      passwordfile => $vidispine::glassfish_asadmin_passfile,
      user         => $vidispine::glassfish_user,
      require      => $jvmoption_reqs,
    #  before       => Staging::Deploy["Vidispine_${vidispine::vidispine_version}_SoftwareInstaller.zip"],
    }

    # add -XX:MaxPermSize jvm option for vidispine glassfish instance
    jvmoption {"-XX:MaxPermSize=${vidispine::glassfish_jvmoptions_maxpermsize}":
      ensure       => present,
      target       => $jvmoption_target,
      portbase     => $vidispine::glassfish_admin_portbase,
      asadminuser  => $vidispine::glassfish_asadmin_user,
      passwordfile => $vidispine::glassfish_asadmin_passfile,
      user         => $vidispine::glassfish_user,
      require      => $jvmoption_reqs,
    #  before       => Staging::Deploy["Vidispine_${vidispine::vidispine_version}_SoftwareInstaller.zip"],
    }
  }

}

