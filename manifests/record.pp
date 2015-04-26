# Define new DNS record
define dns::record (
  $domain   = undef,
  $label    = $title,
  $target   = undef,
  $type     = undef,
  $priority = undef,
)
{

  $dnstype = upcase($type)

  if $label == undef {
    $label = $title
  }
  if $dnstype =~ /(CNAME|SRV|TXT|A)/ {
    $line = "${label} IN ${dnstype} ${target}"
  }
  elsif $dnstype == 'MX' {
    $line = "${label} IN ${dnstype} ${priority} ${target}"
  }
  else {
    warning('Incorrect DNS record type specified')
  }


  file_line { "static.${domain}.${title}":
    path    => "${::dns::zonefilepath}/db.${domain}.static",
    line    => $line,
    tag     => "dns-static-${domain}",
  }


}
