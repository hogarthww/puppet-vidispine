#This will Configure a transcoder for vidispine via the API
#it requires the transcoders external address and details on how to communicate with vidispine
define vidispine::storage_method (
  $ensure     = 'present',
  $vshostname = $vidispine::gfhost,
  $vsport     = $vidispine::gfport,
  $vsuser     = $vidispine::vsadminuser,
  $vspass     = $vidispine::vsadminpass,
  $location   = undef,
  $read       = 'true',
  $write      = 'true',
  $browse     = 'true'
){
  #need to call provider to make call  to the vidispine application server on:/API/resource/transcoder
  vidispine_storage_method {$name:
    ensure     => $ensure,
    vshostname => $vshostname,
    vsport     => $vsport,
    vsuser     => $vsuser,
    vspass     => $vspass,
    location   => $location,
    read       => $read,
    write      => $write,
    browse     => $browse
  }

}
