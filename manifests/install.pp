# see README.md
class vidispine::install {

  if ($::vidispine::legacy_installation) {
    class { '::vidispine::install::legacy': }
    contain '::vidispine::install::legacy'
  }

}
