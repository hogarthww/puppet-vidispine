class vidispine::repository {

  apt::key { 'vidispine':
    id      => 'A1D46CE8C598011F69F7EC9CDFC2B46E1A43C0E4',
    content => file("${module_name}/vidispine-apt.gpg"),
  } ->

  apt::source { 'vidispine':
    location => 'http://repo.vidispine.com/apt',
    release  => "${::lsbdistcodename}/stable",
    repos    => $::vidispine::version_base,
    before   => [
      #Package['transcoder'],
      Package['vidispine-server'],
      #Package['vidispine-solr'],
      #Package['vidispine-tools'],
    ],
  }

}

