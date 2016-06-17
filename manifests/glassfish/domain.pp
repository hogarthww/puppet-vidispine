class vidispine::glassfish::domain {
  class {'::vidispine::glassfish::domain::create':} ->
  class {'::vidispine::glassfish::domain::configure':} ->
  class {'::vidispine::glassfish::domain::service':}
  
  contain '::vidispine::glassfish::domain::create'
  contain '::vidispine::glassfish::domain::configure'
  contain '::vidispine::glassfish::domain::service'
}

