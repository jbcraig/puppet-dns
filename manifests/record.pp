# Define new DNS record
define dns::record (
  $domain   = undef,
  $label    = $title,
  $target   = undef,
  $type     = undef,
  $priority = undef,
)
{

  if $label == undef {
    $label = $title
  }
  if upcase($type) =~ /(CNAME|SRV|TXT)/ {
    $type = upcase($type)
    $line = "${label} IN ${type} ${target}"
  }
  elsif upcase($type) == 'MX' {
    $type = upcase($type)
    $line = "${label} IN ${type} ${priority} ${target}"
  }
  else {
    warning('Incorrect DNS record type specified')
  }


  file_line { "static.${title}":
    path    => "/etc/bind/${domain}.static",
    line    => $line,
    tag     => "dns-static-${domain}",
  }


}
