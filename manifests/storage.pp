#This will Configure a transcoder for vidispine via the API
#it requires the transcoders external address and details on how to communicate with vidispine
define vidispine::storage (
  $ensure     = 'present',
  $vshostname = $vidispine::gfhost,
  $vsport     = $vidispine::gfport,
  $vsuser     = $vidispine::vsadminuser,
  $vspass     = $vidispine::vsadminpass,
){
  #need to call provider to make call  to the vidispine application server on:/API/resource/transcoder
  vidispine_storage {$name:
    ensure     => $ensure,
    vshostname => $vshostname,
    vsport     => $vsport,
    vsuser     => $vsuser,
    vspass     => $vspass,
  }

}
