# This will Configure a transcoder for vidispine via the API
# it requires the transcoders external address and details on how to communicate with vidispine
define vidispine::transcoder (

  $ensure = 'present',
  $vsurl  = $vidispine::api_url,
  $vsuser = $vidispine::vidispine_admin_user,
  $vspass = $vidispine::vidispine_admin_password,
  $url    = $name,

) {

  vidispine_transcoder { $name :
    ensure => $ensure,
    vsurl  => $vsurl,
    vsuser => $vsuser,
    vspass => $vspass,
    url    => $url,
  }

}
