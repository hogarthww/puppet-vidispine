class vidispine::newrelic_agent {

  warning('This code is going away soon. New Relic agent installation should be handled from the profile module.')

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
    content => template('vidispine/newrelic.yml.erb'),
    owner   => $vidispine::glassfish_user,
    group   => $vidispine::glassfish_group,
    require => Staging::Deploy["newrelic-java-${vidispine::newrelic_version}.zip"],
    before  => Jvmoption["-javaagent:${new_relic_dir}/newrelic.jar"],
  }

  jvmoption {"-javaagent:${new_relic_dir}/newrelic.jar" :
    ensure       => present,
    target       => $vidispine::install::jvmoption_target,
    portbase     => $vidispine::glassfish_admin_portbase,
    asadminuser  => $vidispine::glassfish_asadmin_user,
    passwordfile => $vidispine::glassfish_asadmin_passfile,
    user         => $vidispine::glassfish_user,
    require      => $vidispine::install::jvmoption_reqs,
  }

}

