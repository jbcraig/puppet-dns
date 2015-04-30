# Define new DNS record
define dns::record (
  $zone     = undef,
  $label    = undef,
  $target   = undef,
  $type     = undef,
  $priority = undef,
  $comment  = '',
)
{

  $dnstype = upcase($type)

  if ($label == undef) or ($zone == undef) {
    $domain_array = split($title, '[.]' )
    $_label = values_at($domain_array, 0)
    $_zone = join(delete_at($domain_array, 0), '.')
  } else {
    $_label = $label
    $_zone = $zone
  }
  
  if $dnstype =~ /(CNAME|SRV|TXT|A|PTR)/ {
    $line = "${_label} IN ${dnstype} ${target}  ; ${comment}"
  }
  elsif $dnstype == 'MX' {
    $line = "${_label} IN ${dnstype} ${priority} ${target}  ; ${comment}"
  }
  else {
    warning('Incorrect DNS record type specified')
  }

  concat_fragment { "dns-static-${_zone}+${title}.dnsstatic":
    content => $line,
  }


}
