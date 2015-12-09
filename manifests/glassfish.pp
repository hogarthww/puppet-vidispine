class vidispine::glassfish {

  class { '::vidispine::glassfish::install':}
  contain '::vidispine::glassfish::install'
  
  class { '::vidispine::glassfish::imq':
    require => Class['::vidispine::glassfish::install'],
  }
  contain '::vidispine::glassfish::imq'
  
  class { '::vidispine::glassfish::domain':
    require => Class['::vidispine::glassfish::install'],
  }
  contain '::vidispine::glassfish::domain'

}
