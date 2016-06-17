class vidispine::glassfish::domain::service {

  glassfish::create_service {$::vidispine::glassfish_domain_name:
    service_name => $::vidispine::glassfish_domain_name,
    domain_name  => $::vidispine::glassfish_domain_name,
    mode         => 'domain',
    running      => true,
  }

}
