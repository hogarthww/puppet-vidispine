class vidispine::license {

  # TODO: These will be different for Jetty based installs
  $path = sprintf("%s/%s/glassfish/domains/%s",
    $::vidispine::glassfish_parent_dir,
    $::vidispine::glassfish_install_dir,
    $::vidispine::glassfish_domain_name)

  $owner = $::vidispine::glassfish_user
  $group = $::vidispine::glassfish_group
  $mode  = '0640'

  Class['::vidispine::install'] -> Vidispine::License::Master <||>
  Class['::vidispine::install'] -> Vidispine::License::Slaveauth <||>

  Vidispine::License::Master <||> -> Vidispine::Import_setting <||>
  Vidispine::License::Master <||> -> Vidispine::Storage <||>
  Vidispine::License::Master <||> -> Vidispine::Storage_method <||>
  Vidispine::License::Master <||> -> Vidispine::System_field <||>
  Vidispine::License::Master <||> -> Vidispine::Thumbnails <||>
  Vidispine::License::Master <||> -> Vidispine::Transcoder <||>

  Vidispine::License::Slaveauth <||> -> Vidispine::Import_setting <||>
  Vidispine::License::Slaveauth <||> -> Vidispine::Storage <||>
  Vidispine::License::Slaveauth <||> -> Vidispine::Storage_method <||>
  Vidispine::License::Slaveauth <||> -> Vidispine::System_field <||>
  Vidispine::License::Slaveauth <||> -> Vidispine::Thumbnails <||>
  Vidispine::License::Slaveauth <||> -> Vidispine::Transcoder <||>

}

