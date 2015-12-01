class vidispine::glassfish::imq_enhanced {

  fail('vidispine::glassfish::imq_enhanced is not supported, code exists for reference only.')

  # we need to have started imqbrokerd before configuring the enhanced broker cluster
  if ($vidispine::glassfish_imq_cluster_enable) {

    $imq_conf = "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/glassfish/domains/${vidispine::glassfish_domain_name}/imq/instances/imqbroker/props/config.properties"

    ini_setting { 'imq-brokerid' :
      ensure            => present,
      key_val_separator => '=',
      section           => '',
      path              => $imq_conf,
      setting           => 'imq.brokerid',
                          # This is a linting warning but I don't want to touch it at the moment
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
}

