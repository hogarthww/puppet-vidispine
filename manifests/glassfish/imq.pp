class vidispine::glassfish::imq {

  # set imq JAVA_HOME
  ini_setting { 'imq-java-home' :
    ensure            => present,
    key_val_separator => '=',
    section           => '',
    path              => "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/mq/etc/imqenv.conf",
    setting           => 'IMQ_DEFAULT_JAVAHOME',
    value             => "\"/usr/lib/jvm/${vidispine::glassfish_java_package}-${vidispine::glassfish_java_vendor}/jre\"",
    #require           => Class['glassfish'],
  }

  # set imq jvm_args
  file {"${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/mq/bin/imqbrokerd":
    owner   => $vidispine::glassfish_user,
    group   => $vidispine::glassfish_group,
    mode    => '0755',
    content => template("vidispine/glassfish-${vidispine::glassfish_version}/mq/bin/imqbrokerd"),
  #  require => Class['glassfish'],
  }

  # set imq broker maxbytespermsg
  ini_setting { 'imq-broker-maxbytespermsg' :
    ensure            => present,
    key_val_separator => '=',
    section           => '',
    path              => "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/mq/lib/props/broker/default.properties",
    setting           => 'imq.autocreate.destination.maxBytesPerMsg',
    value             => $vidispine::glassfish_imq_maxbytespermsg,
    #require           => Class['glassfish'],
  }

  ## Everything below could be separated out into a new class - IMQ Enhanced
  ## it needs to run after the Vidispine installer
  ## commenting it out temporarily
  ##
  
#  # we need to have started imqbrokerd before configuring the enhanced broker cluster
#  if ($vidispine::glassfish_imq_cluster_enable) {
#
#    $imq_conf = "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/glassfish/domains/${vidispine::glassfish_domain_name}/imq/instances/imqbroker/props/config.properties"
#
#    ini_setting { 'imq-brokerid' :
#      ensure            => present,
#      key_val_separator => '=',
#      section           => '',
#      path              => $imq_conf,
#      setting           => 'imq.brokerid',
#                          # This is a linting warning but I don't want to touch it at the moment
#      value             => "${vidispine::glassfish_imq_broker_list[$::fqdn][brokerid]}",
#      require           => Exec['vidispine-installer'],
#    }
#
#    ini_setting { 'imq-cluster-ha' :
#      ensure            => present,
#      key_val_separator => '=',
#      section           => '',
#      path              => $imq_conf,
#      setting           => 'imq.cluster.ha',
#      value             => 'true',
#      require           => Ini_setting['imq-brokerid'],
#    }
#
#    ini_setting { 'imq-cluster-clusterid' :
#      ensure            => present,
#      key_val_separator => '=',
#      section           => '',
#      path              => $imq_conf,
#      setting           => 'imq.cluster.clusterid',
#      value             => 'vidispineimq',
#      require           => Ini_setting['imq-cluster-ha'],
#    }
#
#    ini_setting { 'imq-persist-store' :
#      ensure            => present,
#      key_val_separator => '=',
#      section           => '',
#      path              => $imq_conf,
#      setting           => 'imq.persist.store',
#      value             => 'jdbc',
#      require           => Ini_setting['imq-cluster-clusterid'],
#    }
#
#    ini_setting { 'imq-persist-jdbc-dbvendor' :
#      ensure            => present,
#      key_val_separator => '=',
#      section           => '',
#      path              => $imq_conf,
#      setting           => 'imq.persist.jdbc.dbVendor',
#      value             => 'postgresql',
#      require           => Ini_setting['imq-persist-store'],
#    }
#
#    ini_setting { 'imq-persist-jdbc-postgresql-opendburl' :
#      ensure            => present,
#      key_val_separator => '=',
#      section           => '',
#      path              => $imq_conf,
#      setting           => 'imq.persist.jdbc.postgresql.opendburl',
#      value             => "jdbc\\:postgresql\\://${vidispine::postgresql_host}\\:${vidispine::postgresql_port}/${vidispine::postgresql_imq_database}",
#      require           => Ini_setting['imq-persist-jdbc-dbvendor'],
#    }
#
#    ini_setting { 'imq-persist-jdbc-postgresql-user' :
#      ensure            => present,
#      key_val_separator => '=',
#      section           => '',
#      path              => $imq_conf,
#      setting           => 'imq.persist.jdbc.postgresql.user',
#      value             => $vidispine::postgresql_imq_user,
#      require           => Ini_setting['imq-persist-jdbc-postgresql-opendburl'],
#    }
#
#    ini_setting { 'imq-persist-jdbc-postgresql-password' :
#      ensure            => present,
#      key_val_separator => '=',
#      section           => '',
#      path              => $imq_conf,
#      setting           => 'imq.persist.jdbc.postgresql.password',
#      value             => $vidispine::postgresql_imq_password,
#      require           => Ini_setting['imq-persist-jdbc-postgresql-user'],
#    }
#  }

}

