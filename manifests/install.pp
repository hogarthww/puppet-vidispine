# see README.md
class vidispine::install {

  # create directory for vidispine installer
  # if cluster and not das don't bother **
  file {[ $vidispine::installer_dir, "${vidispine::installer_dir}/Vidispine_${vidispine::vidispine_version}"]:
    ensure => directory,
    owner  => $vidispine::glassfish_user,
    group  => $vidispine::glassfish_group,
    mode   => '0755',
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
    require => File["${vidispine::installer_dir}/Vidispine_${vidispine::vidispine_version}"],
  }

  # create silent install config.xml file for vidispine installer
  # if cluster and not das don't bother **
  file { "${vidispine::installer_dir}/Vidispine_${vidispine::vidispine_version}/config.xml":
    owner   => $vidispine::glassfish_user,
    group   => $vidispine::glassfish_group,
    mode    => '0644',
    content => template('vidispine/config.xml.erb'),
    require => Staging::Deploy["Vidispine_${vidispine::vidispine_version}_SoftwareInstaller.zip"],
    notify  => Exec['vidispine-installer'],
  }

  # 02/07/2015 - decision made to only ever run the Vidispine installer once, by adding
  # a 'creates' parameter.
  #
  # Why?
  #  * We're moving towards an immutable server model where Vidispine is never upgraded
  #    in-place; instead we always build a new box. Running the installer to execute an
  #    upgrade is not a valid use case any more.
  #
  #  * When a config parameter is changed which would have gone into the installer's
  #    config.xml and also into the REST API as a System Field, we don't want to run
  #    the installer again. Before, a refresh of this exec resource would be triggered
  #    by a change to the config.xml. Even though re-running the installer is (supposed
  #    to be) idempotent, it can take a very long time to complete.
  #
  # Of course Vidispine 4.3 replaces the installer with a Debian package and this will
  # all go away very soon.
  #
  exec{'vidispine-installer':
    command     => "java -jar ${vidispine::installer_dir}/Vidispine_${vidispine::vidispine_version}/SetupTool4.jar --no-prompts --only-middleware --run-installer; cp -p ${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/glassfish/lib/postgresql-*.jar ${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/mq/lib/ext/",
    path        => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
    cwd         => "${vidispine::installer_dir}/Vidispine_${vidispine::vidispine_version}",
    user        => $vidispine::glassfish_user,
    timeout     => 0,
    creates     => "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/glassfish/domains/${vidispine::glassfish_domain_name}/applications/vidispine",
  }


  if ($vidispine::solrcloud_enable) {
    application { 'solr':
      ensure       => absent,
      asadminuser  => $vidispine::glassfish_asadmin_user,
      passwordfile => $vidispine::glassfish_asadmin_passfile,
      user         => $vidispine::glassfish_user,
      require      => Exec['vidispine-installer'],
    }
  }

  if ($vidispine::newrelic_version) {
    include 'vidispine::newrelic_agent'
  }
}
