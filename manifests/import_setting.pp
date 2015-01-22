#This will Configure a transcoder for vidispine via the API
#it requires the transcoders external address and details on how to communicate with vidispine
define vidispine::import_setting (
  $ensure     = 'present',
  $vshostname = $vidispine::gfhost,
  $vsport     = $vidispine::gfport,
  $vsuser     = $vidispine::vsadminuser,
  $vspass     = $vidispine::vsadminpass,
  $permission = undef,
  $group      = $name,
){
  #need to call provider to make call  to the vidispine application server on:/API/resource/transcoder
  vidispine_import_setting {$group:
    ensure     => $ensure,
    vshostname => $vshostname,
    vsport     => $vsport,
    vsuser     => $vsuser,
    vspass     => $vspass,
    group      => $group,
    permission => $permission,
  }

}
