# This will configure Vidispine thumbnail resources via the API

define vidispine::thumbnails (

  $ensure = 'present',
  $vsurl  = $vidispine::api_url,
  $vsuser = $vidispine::vidispine_admin_user,
  $vspass = $vidispine::vidispine_admin_password,
  $path   = $name,

){

  #need to call provider to make call  to the vidispine application server on:/API/resource/transcoder
  vidispine_thumbnails {$path:
    ensure => $ensure,
    vsurl  => $vsurl,
    vsuser => $vsuser,
    vspass => $vspass,
  }

}
