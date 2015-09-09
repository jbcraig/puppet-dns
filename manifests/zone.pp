# Define new zone for the dns
define dns::zone (
    $zonetype       = 'master',
    $soa            = $::fqdn,
    $reverse        = false,
    $ttl            = '10800',
    $soaip          = $::ipaddress,
    $refresh        = 86400,
    $update_retry   = 3600,
    $expire         = 604800,
    $negttl         = 3600,
    $serial         = 1,
    $masters        = [],
    $allow_transfer = [],
    $zone           = $title,
    $contact        = "root.${title}.",
    $zonefilepath   = $::dns::zonefilepath,
    $filename       = "db.${title}",
    $static_records = false,
) {

  validate_bool($reverse, $static_records)
  validate_array($masters, $allow_transfer)

  $zonefilename = "${zonefilepath}/${filename}"

  concat::fragment { "dns_zones+10_${zone}.dns":
    target  => $::dns::publicviewpath,
    content => template('dns/named.zone.erb'),
    order   => "10-${zone}",
  }

  file { $zonefilename:
    ensure  => file,
    owner   => $dns::user,
    group   => $dns::group,
    mode    => '0644',
    content => template('dns/zone.header.erb'),
    replace => false,
    notify  => Service[$::dns::namedservicename],
  }

  if ($static_records == true) and ($zonetype == 'master')  {
    concat::fragment { "dns-static-${zone}+01header.dnsstatic":
      target  => "${zonefilename}.nsupdate",
      content => template('dns/static-header.erb'),
    }
  
    Dns::Record <<| |>> { notify => Concat_build["dns-static-${zone}"] }
  
    concat { "dns-static-${zone}":
      owner   => $dns::user,
      group   => $dns::group,
      mode    => '0644',
      notify  => Exec["update_dns_${zone}"],
    }

    exec { "update_dns_${zone}":
      command     => "${::dns::zonefilepath}/nsupdate_wrapper ${zone}",
      refreshonly => true,
      require     => [
        File["${zonefilename}.nsupdate"],
        File['nsupdate_wrapper'],
        File[$zonefilename],
      ],
    }
  }

}
