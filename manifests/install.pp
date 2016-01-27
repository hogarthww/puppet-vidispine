# see README.md
class vidispine::install {

  # Compose location strings in a robust way that handles trailing slashes
  #
  $installer_filename = "Vidispine_${::vidispine::vidispine_version}_SoftwareInstaller.zip"

  $installer_source = sprintf('%s/%s',
                        regsubst($::vidispine::vidispine_archive_location, '\/$', ''),
                        $installer_filename)

  $installer_target = sprintf('%s/Vidispine_%s',
                        regsubst($::vidispine::installer_dir, '\/$', ''),
                        $::vidispine::vidispine_version)

  $setuptool_jar = "${installer_target}/SetupTool4.jar"

  $config_xml = "${installer_target}/config.xml"

  file {[ $vidispine::installer_dir, $installer_target ]:
    ensure => directory,
    owner  => $vidispine::glassfish_user,
    group  => $vidispine::glassfish_group,
    mode   => '0755',
  }

  staging::deploy { $installer_filename :
    source  => $installer_source,
    target  => $installer_target,
    timeout => 0,
    user    => $vidispine::glassfish_user,
    group   => $vidispine::glassfish_group,
    creates => $setuptool_jar,
    require => File[$installer_target],
  }

  # Create silent install config.xml file for Vidispine installer
  file { $config_xml :
    owner   => $vidispine::glassfish_user,
    group   => $vidispine::glassfish_group,
    mode    => '0644',
    content => template('vidispine/config.xml.erb'),
    require => Staging::Deploy[$installer_filename],
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
  exec { 'vidispine-installer' :
    command => "java -jar ${setuptool_jar} --no-prompts --only-middleware --run-installer",
    path    => [ "${::vidispine::java_home}/bin", '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
    cwd     => "${vidispine::installer_dir}/Vidispine_${vidispine::vidispine_version}",
    user    => $vidispine::glassfish_user,
    timeout => 0,
    creates => "${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/glassfish/domains/${vidispine::glassfish_domain_name}/applications/vidispine",
  } ~>

  exec { 'copy postgresql jars':
    command     => "cp -p ${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/glassfish/lib/postgresql-*.jar ${vidispine::glassfish_parent_dir}/${vidispine::glassfish_install_dir}/mq/lib/ext/",
    path        => ['/bin'],
    cwd         => "${vidispine::installer_dir}/Vidispine_${vidispine::vidispine_version}",
    user        => $vidispine::glassfish_user,
    timeout     => 0,
    refreshonly => true,
  }

  if ($vidispine::solrcloud_enable) {
    glassfish_application { 'solr':
      ensure       => absent,
      asadminuser  => $vidispine::glassfish_asadmin_user,
      passwordfile => $vidispine::glassfish_asadmin_passfile,
      user         => $vidispine::glassfish_user,
      require      => Exec['vidispine-installer'],
    }
  }

}
