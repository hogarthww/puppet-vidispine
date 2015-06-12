# see README.md
class vidispine::install {

  # add hogarthww apt repo if we don't have it
  if !defined(Apt::Source[$vidispine::glassfish_java_apt_repo['name']]) {
    apt::source { $vidispine::glassfish_java_apt_repo['name']:
      comment     => $vidispine::glassfish_java_apt_repo['comment'],
      location    => $vidispine::glassfish_java_apt_repo['location'],
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
    notify  => Service[$vidispine::glassfish_domain_name],
  }

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

  # set glassfish JAVA_HOME
  ini_setting { 'as-java' :
    ensure            => present,
    key_val_separator => '=',
    section           => '',
    path              => "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/glassfish/config/asenv.conf",
    setting           => 'AS_JAVA',
    value             => "\"/usr/lib/jvm/${vidispine::glassfish_java_package}-${vidispine::glassfish_java_vendor}/jre\"",
    require           => Class['glassfish'],
  }

  # set imq JAVA_HOME
  ini_setting { 'imq-java-home' :
    ensure            => present,
    key_val_separator => '=',
    section           => '',
    path              => "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/mq/etc/imqenv.conf",
    setting           => 'IMQ_DEFAULT_JAVAHOME',
    value             => "\"/usr/lib/jvm/${vidispine::glassfish_java_package}-${vidispine::glassfish_java_vendor}/jre\"",
    require           => Class['glassfish'],
  }

  # set imq jvm_args
  file {"${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/mq/bin/imqbrokerd":
    owner   => $vidispine::glassfish_user,
    group   => $vidispine::glassfish_group,
    mode    => '0755',
    content => template("vidispine/glassfish-${vidispine::glassfish_version}/mq/bin/imqbrokerd"),
    require => Class['glassfish'],
  }

  # set imq broker maxbytespermsg
  ini_setting { 'imq-broker-maxbytespermsg' :
    ensure            => present,
    key_val_separator => '=',
    section           => '',
    path              => "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/mq/lib/props/broker/default.properties",
    setting           => 'imq.autocreate.destination.maxBytesPerMsg',
    value             => $vidispine::glassfish_imq_maxbytespermsg,
    require           => Class['glassfish'],
  }

  if ($vidispine::glassfish_das_host == 'localhost') or ($vidispine::glassfish_das_host == $::fqdn) {
    # create glassfish domain if we are running the das
    glassfish::create_domain { $vidispine::glassfish_domain_name:
      asadmin_user        => $vidispine::glassfish_asadmin_user,
      asadmin_passfile    => $vidispine::glassfish_asadmin_passfile,
      create_service      => false,
      domain_user         => $vidispine::glassfish_user,
      enable_secure_admin => true,
      portbase            => $vidispine::glassfish_das_portbase,
      start_domain        => true,
      require             => [
        Ini_setting['as-java'],
        Ini_setting['imq-java-home'],
        File["${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/mq/bin/imqbrokerd"],
        Ini_setting['imq-broker-maxbytespermsg'],
      ],
    }

    # set default java-home if we are running the das
    set { 'default-config.java-config.java-home':
      ensure       => present,
      value        => "/usr/lib/jvm/${vidispine::glassfish_java_package}-${vidispine::glassfish_java_vendor}/jre",
      dashost      => $vidispine::glassfish_das_host,
      portbase     => $vidispine::glassfish_das_portbase,
      asadminuser  => $vidispine::glassfish_asadmin_user,
      passwordfile => $vidispine::glassfish_asadmin_passfile,
      user         => $vidispine::glassfish_user,
      require      => Glassfish::Create_domain[$vidispine::glassfish_domain_name],
    }

    # set server java-home if we are running the das
    set { 'server.java-config.java-home':
      ensure       => present,
      value        => "/usr/lib/jvm/${vidispine::glassfish_java_package}-${vidispine::glassfish_java_vendor}/jre",
      dashost      => $vidispine::glassfish_das_host,
      portbase     => $vidispine::glassfish_das_portbase,
      asadminuser  => $vidispine::glassfish_asadmin_user,
      passwordfile => $vidispine::glassfish_asadmin_passfile,
      user         => $vidispine::glassfish_user,
      require      => Glassfish::Create_domain[$vidispine::glassfish_domain_name],
    }

    # set server http-listener-1.port if we are running the das
    set { 'server-config.network-config.network-listeners.network-listener.http-listener-1.port':
      ensure       => present,
      value        => $vidispine::glassfish_http_port,
      dashost      => $vidispine::glassfish_das_host,
      portbase     => $vidispine::glassfish_das_portbase,
      asadminuser  => $vidispine::glassfish_asadmin_user,
      passwordfile => $vidispine::glassfish_asadmin_passfile,
      user         => $vidispine::glassfish_user,
      require      => Glassfish::Create_domain[$vidispine::glassfish_domain_name],
    }

    # set server system-property.HTTP_LISTENER_PORT.value if we are running the das
    set { 'default-config.system-property.HTTP_LISTENER_PORT.value':
      ensure       => present,
      value        => $vidispine::glassfish_http_port,
      dashost      => $vidispine::glassfish_das_host,
      portbase     => $vidispine::glassfish_das_portbase,
      asadminuser  => $vidispine::glassfish_asadmin_user,
      passwordfile => $vidispine::glassfish_asadmin_passfile,
      user         => $vidispine::glassfish_user,
      require      => Glassfish::Create_domain[$vidispine::glassfish_domain_name],
    }

    if ($vidispine::glassfish_cluster_enable) {
      # set cluster_name java-home if we are running the das and part of a cluster
      set { "${vidispine::glassfish_cluster_name}-config.java-config.java-home":
        ensure       => present,
        value        => "/usr/lib/jvm/${vidispine::glassfish_java_package}-${vidispine::glassfish_java_vendor}/jre",
        dashost      => $vidispine::glassfish_das_host,
        portbase     => $vidispine::glassfish_das_portbase,
        asadminuser  => $vidispine::glassfish_asadmin_user,
        passwordfile => $vidispine::glassfish_asadmin_passfile,
        user         => $vidispine::glassfish_user,
        require      => Glassfish::Create_domain[$vidispine::glassfish_domain_name],
      }

    }

  }

#      # set jvmoptions for cluster_name if we are running the das and part of a cluster
#      $jvmoption_target = $vidispine::glassfish_cluster_name,
#
#    } else {
#      # set jvmoptions for 'server' if we are running the das and not part of a cluster
#      $jvmoption_target = 'server',
#
#    }

  $jvmoption_target = 'server'

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
    jvmoption {"-Xmx512m":
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
    jvmoption {"-XX:PermSize=64m":
      ensure       => absent,
      target       => $jvmoption_target,
      portbase     => $vidispine::glassfish_admin_portbase,
      asadminuser  => $vidispine::glassfish_asadmin_user,
      passwordfile => $vidispine::glassfish_asadmin_passfile,
      user         => $vidispine::glassfish_user,
      require      => $jvmoption_reqs,
      before       => Staging::Deploy["Vidispine_${vidispine::vidispine_version}_SoftwareInstaller.zip"],
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
      before       => Staging::Deploy["Vidispine_${vidispine::vidispine_version}_SoftwareInstaller.zip"],
    }
  }

  # We don't want to have duplicate declarations if we are trying to set the
  # -XX:MaxPermSize to 192m.
  if $vidispine::glassfish_jvmoptions_maxpermsize != '192m' {
  # remove -XX:MaxPermSize=192m jvm option for vidispine glassfish instance
    jvmoption {"-XX:MaxPermSize=192m":
      ensure       => absent,
      target       => $jvmoption_target,
      portbase     => $vidispine::glassfish_admin_portbase,
      asadminuser  => $vidispine::glassfish_asadmin_user,
      passwordfile => $vidispine::glassfish_asadmin_passfile,
      user         => $vidispine::glassfish_user,
      require      => $jvmoption_reqs,
      before       => Staging::Deploy["Vidispine_${vidispine::vidispine_version}_SoftwareInstaller.zip"],
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
      before       => Staging::Deploy["Vidispine_${vidispine::vidispine_version}_SoftwareInstaller.zip"],
    }
  }

  # create directory for vidispine installer
  # if cluster and not das don't bother **
  file {[ $vidispine::installer_dir, "${vidispine::installer_dir}/Vidispine_${vidispine::vidispine_version}"]:
    ensure  => directory,
    owner   => $vidispine::glassfish_user,
    group   => $vidispine::glassfish_group,
    mode    => '0755',
  }

  # unpack vidispine installer
  # if cluster and not das don't bother **
  staging::deploy{"Vidispine_${vidispine::vidispine_version}_SoftwareInstaller.zip":
    source  => "${vidispine::vidispine_archive_location}Vidispine_${vidispine::vidispine_version}_SoftwareInstaller.zip",
    target  => "${vidispine::installer_dir}/Vidispine_${vidispine::vidispine_version}",
    timeout => 0,
    user    => $vidispine::glassfish_user,
    group   => $vidispine::glassfish_group,
    creates => "${vidispine::installer_dir}/Vidispine_${vidispine::vidispine_version}/SetupTool4.jar",
    require => [
                 Jvmoption["-Xmx${vidispine::glassfish_jvmoptions_xmx}"],
                 Jvmoption["-Xms${vidispine::glassfish_jvmoptions_xms}"],
                 File["${vidispine::installer_dir}/Vidispine_${vidispine::vidispine_version}"],
               ]
  }

  if ($vidispine::glassfish_cluster_enable) or ($vidispine::glassfish_imq_cluster_enable) {
    $zookeeper_servers = join(sort(keys($vidispine::zookeeper_server_list)), ',')
  }

  # create silent install config.xml file for vidispine installer
  # if cluster and not das don't bother **
  file { "${vidispine::installer_dir}/Vidispine_${vidispine::vidispine_version}/config.xml":
    owner   => $vidispine::glassfish_user,
    group   => $vidispine::glassfish_group,
    mode    => '0644',
    content => template("vidispine/config.xml.erb"),
    require => Staging::Deploy["Vidispine_${vidispine::vidispine_version}_SoftwareInstaller.zip"],
    notify  => Exec['vidispine-installer'],
  }

  exec{'vidispine-installer':
    command     => "java -jar ${vidispine::installer_dir}/Vidispine_${vidispine::vidispine_version}/SetupTool4.jar --no-prompts --only-middleware --run-installer; cp -p ${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/glassfish/lib/postgresql-*.jar /opt/glassfish3/mq/lib/ext/",
    path        => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
    cwd         => "${vidispine::installer_dir}/Vidispine_${vidispine::vidispine_version}",
    user        => $vidispine::glassfish_user,
    timeout     => 0,
    refreshonly => true,
    subscribe   => File["${vidispine::installer_dir}/Vidispine_${vidispine::vidispine_version}/config.xml"],
  }

  # we need to have started imqbrokerd before configuring the enhanced broker cluster
  if ($vidispine::glassfish_imq_cluster_enable) {

    $imq_conf = "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/glassfish/domains/${vidispine::glassfish_domain_name}/imq/instances/imqbroker/props/config.properties"

    ini_setting { 'imq-brokerid' :
      ensure            => present,
      key_val_separator => '=',
      section           => '',
      path              => $imq_conf,
      setting           => 'imq.brokerid',
      value             => "${vidispine::glassfish_imq_broker_list[$::fqdn][brokerid]}",
      require           => Exec['vidispine-installer'],
    }

    ini_setting { 'imq-cluster-ha' :
      ensure            => present,
      key_val_separator => '=',
      section           => '',
      path              => $imq_conf,
      setting           => 'imq.cluster.ha',
      value             => 'true',
      require           => Ini_setting['imq-brokerid'],
    }

    ini_setting { 'imq-cluster-clusterid' :
      ensure            => present,
      key_val_separator => '=',
      section           => '',
      path              => $imq_conf,
      setting           => 'imq.cluster.clusterid',
      value             => 'vidispineimq',
      require           => Ini_setting['imq-cluster-ha'],
    }

    ini_setting { 'imq-persist-store' :
      ensure            => present,
      key_val_separator => '=',
      section           => '',
      path              => $imq_conf,
      setting           => 'imq.persist.store',
      value             => 'jdbc',
      require           => Ini_setting['imq-cluster-clusterid'],
    }

    ini_setting { 'imq-persist-jdbc-dbvendor' :
      ensure            => present,
      key_val_separator => '=',
      section           => '',
      path              => $imq_conf,
      setting           => 'imq.persist.jdbc.dbVendor',
      value             => 'postgresql',
      require           => Ini_setting['imq-persist-store'],
    }

    ini_setting { 'imq-persist-jdbc-postgresql-opendburl' :
      ensure            => present,
      key_val_separator => '=',
      section           => '',
      path              => $imq_conf,
      setting           => 'imq.persist.jdbc.postgresql.opendburl',
      value             => "jdbc\\:postgresql\\://${vidispine::postgresql_host}\\:${vidispine::postgresql_port}/${vidispine::postgresql_imq_database}",
      require           => Ini_setting['imq-persist-jdbc-dbvendor'],
    }

    ini_setting { 'imq-persist-jdbc-postgresql-user' :
      ensure            => present,
      key_val_separator => '=',
      section           => '',
      path              => $imq_conf,
      setting           => 'imq.persist.jdbc.postgresql.user',
      value             => $vidispine::postgresql_imq_user,
      require           => Ini_setting['imq-persist-jdbc-postgresql-opendburl'],
    }

    ini_setting { 'imq-persist-jdbc-postgresql-password' :
      ensure            => present,
      key_val_separator => '=',
      section           => '',
      path              => $imq_conf,
      setting           => 'imq.persist.jdbc.postgresql.password',
      value             => $vidispine::postgresql_imq_password,
      require           => Ini_setting['imq-persist-jdbc-postgresql-user'],
    }

  }

  $new_relic_dir = "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/glassfish/domains/${vidispine::glassfish_domain_name}/newrelic"

  file { $new_relic_dir :
    ensure  => directory,
    owner   => $vidispine::glassfish_user,
    group   => $vidispine::glassfish_group,
    require => Exec['vidispine-installer'],
  }

  staging::deploy { "newrelic-java-${vidispine::newrelic_version}.zip" :
    source  => "${vidispine::newrelic_archive_location}newrelic-java-${vidispine::newrelic_version}.zip",
    target  => "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/glassfish/domains/${vidispine::glassfish_domain_name}",
    user    => $vidispine::glassfish_user,
    group   => $vidispine::glassfish_group,
    creates => "${new_relic_dir}/newrelic.jar",
    require => File[$new_relic_dir],
  }

  file { "${new_relic_dir}/newrelic.yml" :
    ensure  => file,
    content => template("vidispine/newrelic.yml.erb"),
    owner   => $vidispine::glassfish_user,
    group   => $vidispine::glassfish_group,
    require => Staging::Deploy["newrelic-java-${vidispine::newrelic_version}.zip"],
    before  => Jvmoption["-javaagent:${new_relic_dir}/newrelic.jar"],
  }

  jvmoption {"-javaagent:${new_relic_dir}/newrelic.jar" :
    ensure       => present,
    target       => $jvmoption_target,
    portbase     => $vidispine::glassfish_admin_portbase,
    asadminuser  => $vidispine::glassfish_asadmin_user,
    passwordfile => $vidispine::glassfish_asadmin_passfile,
    user         => $vidispine::glassfish_user,
    require      => $jvmoption_reqs,
  }
}
