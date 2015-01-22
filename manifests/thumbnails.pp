#This will Configure a transcoder for vidispine via the API
#it requires the transcoders external address and details on how to communicate with vidispine
define vidispine::thumbnails (
  $ensure     = 'present',
  $vsversion  = $vidispine::vsversion,
  $vshostname = $vidispine::gfhost,
  $vsport     = $vidispine::gfport,
  $path       = $name,
  $vsuser     = $vidispine::vsadminuser,
  $vspass     = $vidispine::vsadminpass,
){
  #need to call provider to make call  to the vidispine application server on:/API/resource/transcoder
  vidispine_thumbnails {$path:
    ensure     => $ensure,
    vshostname => $vshostname,
    vsport     => $vsport,
    vsuser     => $vsuser,
    vspass     => $vspass,
  }

}
