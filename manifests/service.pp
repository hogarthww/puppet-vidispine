# see README.md
class vidispine::service {

  # this is used by the glassfish domain service template
  $runuser          = $vidispine::glassfish_user

  # these are used by the glassfish instance service template
  #$das_host         = $vidispine::glassfish_das_host
  #$das_port         = $vidispine::glassfish_admin_portbase + 48
  #$asadmin_passfile = $vidispine::glassfish_asadmin_passfile
  #$instance_name    = $vidispine::glassfish_instance_name
  #$node_name        = $::hostname

  if ($vidispine::glassfish_das_host == 'localhost') or ($vidispine::glassfish_das_host == $::fqdn) {

    case $::osfamily {
      'RedHat' : {
        $domain_service_file = template('glassfish/glassfish-init-domain-el.erb')
      }
      'Debian' : {
        $domain_service_file = template('glassfish/glassfish-init-domain-debian.erb')
      }
      default  : {
        fail("OSFamily ${::osfamily} not supported.")
      }
    }

    file { $vidispine::glassfish_domain_name:
      ensure  => present,
      path    => "/etc/init.d/${vidispine::glassfish_domain_name}",
      mode    => '0755',
      content => $domain_service_file,
      notify  => Service[$vidispine::glassfish_domain_name]
    }

    service { $vidispine::glassfish_domain_name:
      ensure     => 'running',
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      require    => [
        File[$vidispine::glassfish_domain_name],
      ],
    }

  }

  if $vidispine::glassfish_cluster_enable {

    case $::osfamily {
      'RedHat' : {
        $instance_service_file = template('glassfish/glassfish-init-instance-el.erb')
      }
      'Debian' : {
        $instance_service_file = template('glassfish/glassfish-init-instance-debian.erb')
      }
      default  : {
        fail("OSFamily ${::osfamily} not supported.")
      }
    }

    file { $vidispine::glassfish_instance_name:
      ensure  => present,
      path    => "/etc/init.d/${vidispine::glassfish_instance_name}",
      mode    => '0755',
      content => $domain_service_file,
      notify  => Service[$vidispine::glassfish_instance_name]
    }

    service { $vidispine::glassfish_instance_name:
      ensure     => 'running',
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      require    => [
        File[$vidispine::glassfish_instance_name],
      ],
    }

  }

}
