class vidispine::glassfish::imq {

  # set imq JAVA_HOME
  ini_setting { 'imq-java-home' :
    ensure            => present,
    key_val_separator => '=',
    section           => '',
    path              => "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/mq/etc/imqenv.conf",
    setting           => 'IMQ_DEFAULT_JAVAHOME',
    value             => "\"/usr/lib/jvm/${vidispine::glassfish_java_package}-${vidispine::glassfish_java_vendor}/jre\"",
  }

  # set imq jvm_args
  file {"${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/mq/bin/imqbrokerd":
    owner   => $vidispine::glassfish_user,
    group   => $vidispine::glassfish_group,
    mode    => '0755',
    content => template("vidispine/glassfish-${vidispine::glassfish_version}/mq/bin/imqbrokerd"),
  }

  # set imq broker maxbytespermsg
  ini_setting { 'imq-broker-maxbytespermsg' :
    ensure            => present,
    key_val_separator => '=',
    section           => '',
    path              => "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/mq/lib/props/broker/default.properties",
    setting           => 'imq.autocreate.destination.maxBytesPerMsg',
    value             => $vidispine::glassfish_imq_maxbytespermsg,
  }

}

