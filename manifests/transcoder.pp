# This will Configure a transcoder for vidispine via the API
# it requires the transcoders external address and details on how to communicate with vidispine
define vidispine::transcoder (

  $ensure     = 'present',
  $vshostname = $vidispine::glassfish_das_host,
  $vsport     = $vidispine::glassfish_http_port,
  $vsuser     = $vidispine::vidispine_admin_user,
  $vspass     = $vidispine::vidispine_admin_password,
  $trans_addr = $name,
  $trans_port = '8888',

){

  # need to call provider to make call  to the vidispine application server on:/API/resource/transcoder
  transcoder_address {"${trans_addr}:${trans_port}":
    ensure     => $ensure,
    vshostname => $vshostname,
    vsport     => $vsport,
    vsuser     => $vsuser,
    vspass     => $vspass,
  }

}
