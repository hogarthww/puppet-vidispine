# see README.md
class vidispine::install {

  #if !defined(Apt::Source['hogarthww']) {
  #  apt::source { 'hogarthww':
  #    comment     => 'The hogarth worldwide apt repo',
  #    location    => 'http://apt.hogarthww.prv/hogarthww/ubuntu/',
  #    release     => $lsbdistcodename,
  #    repos       => 'main',
  #    include_src => false,
  #    include_deb => true,
  #  }
  #}

  #package { 'vidispine':
  #  ensure  => $vidispine::package_ensure,
  #  name    => $vidispine::package_name,
  #  require => Apt::Source['hogarthww'],
  #}

}
