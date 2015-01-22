#This is a bulk metadata ingestion for vidispine - specify a config file in your profile
#this will take the config file and path - check if it already exists - and if not submit it
#there is no deletion or setter methods for properties at this time spaces must be %20
#TODO: break into seperate provider with setters

define vidispine::metadata_bulk (
  $ensure     = 'present',
  $vshostname = $vidispine::gfhost,
  $vsport     = $vidispine::gfport,
  $vsuser     = $vidispine::vsadminuser,
  $vspass     = $vidispine::vsadminpass,
  $filename   = undef,
  $filesource = undef,
  $path       = 'API/metadata-field/field-group',
  $groupName  = $name,
){
  #need to call provider to make call  to the vidispine application server on:/API/resource/transcoder

  file {$filename:
    path   => "/tmp/${filename}",
    source => $filesource,
  }


  exec {$filename:
    command => "curl -X PUT -H 'Content-Type: application/xml' -d @/tmp/$filename --user ${vsuser}:${vspass} http://${vshostname}:${vsport}/${path}/${groupName}",
    unless  => "curl -I --user ${vsuser}:${vspass} http://${vshostname}:${vsport}/${path}/${groupName} | grep 200",
    path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
    require => File[$filename],

  }
}
