# This will Configure a transcoder for vidispine via the API
# it requires the transcoders external address and details on how to communicate with vidispine
define vidispine::system_field (

  $ensure = 'present',
  $vsurl  = $vidispine::api_url,
  $vsuser = $vidispine::vidispine_admin_user,
  $vspass = $vidispine::vidispine_admin_password,
  $value  = undef

){

  # need to call provider to make call  to the vidispine application server on:/API/resource/transcoder
  vidispine_system_field {$name:
    ensure => $ensure,
    vsurl  => $vsurl,
    vsuser => $vsuser,
    vspass => $vspass,
    value  => $value
  }

}
