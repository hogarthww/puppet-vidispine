class vidispine::glassfish::domain::service {

  glassfish::create_service {$::vidispine::glassfish_domain_name:
    service_name => $::vidispine::glassfish_domain_name,
    domain_name  => $::vidispine::glassfish_domain_name,
    mode         => 'domain',
    running      => true,
  }

  if ($::vidispine::glassfish_cluster_enable) {
    glassfish::create_service {$::vidispine::glassfish_instance_name:
      service_name  => $::vidispine_glassfish_instance_name,
      instance_name => $::vidispine_glassfish_instance_name,
      mode          => 'instance',
      running       => false,
    }
  }

}
