# see README.md
class vidispine::config {

  # example setup logrotate
  #file { "/etc/logrotate.d/${vidispine}" :
  #  ensure  => $ensure,
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #  source  => "puppet:///modules/${module_name}/logrotate-${vidispine}",
  #}

  # example setup default env
  #file { '/etc/default/${vidispine}' :
  #  ensure  => $ensure,
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #  content => template("${module_name}/default-${vidispine}.erb"),
  #  notify  => Service[$vidispine::service_name],
  #}

}
