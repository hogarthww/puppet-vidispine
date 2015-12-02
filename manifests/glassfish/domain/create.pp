class vidispine::glassfish::domain::create {

  glassfish::create_domain { $vidispine::glassfish_domain_name:
    asadmin_user        => $vidispine::glassfish_asadmin_user,
    asadmin_passfile    => $vidispine::glassfish_asadmin_passfile,
    create_service      => false,
    domain_user         => $vidispine::glassfish_user,
    enable_secure_admin => true,
    portbase            => $vidispine::glassfish_das_portbase,
    start_domain        => true,
  }

}

