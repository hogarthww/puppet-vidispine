# This will Configure a transcoder for vidispine via the API
# it requires the transcoders external address and details on how to communicate with vidispine
define vidispine::import_setting (

  $ensure     = 'present',
  $vshostname = $vidispine::glassfish_das_host,
  $vsport     = $vidispine::glassfish_http_port,
  $vsuser     = $vidispine::vidispine_admin_user,
  $vspass     = $vidispine::vidispine_admin_password,
  $group      = $name,
  $permission = undef,

){

  # need to call provider to make call  to the vidispine application server on:/API/resource/transcoder
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
