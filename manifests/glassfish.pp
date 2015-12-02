class vidispine::glassfish {

  class {'::vidispine::glassfish::install':}
  
  class {'::vidispine::glassfish::imq':
    require => Class['::vidispine::glassfish::install'],
  }
  
  class {'::vidispine::glassfish::domain':
    require => Class['::vidispine::glassfish::install'],
  }

}
