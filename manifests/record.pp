# Define new DNS record
define dns::record (
  $zone     = undef,
  $label    = $title,
  $target   = undef,
  $type     = undef,
  $priority = undef,
  $tag      = "dns_static_${zone}",
)
{

  tag $tag
  $dnstype = upcase($type)

  if $label == undef {
    $label = $title
  }
  if $dnstype =~ /(CNAME|SRV|TXT|A|PTR)/ {
    $line = "${label} IN ${dnstype} ${target}"
  }
  elsif $dnstype == 'MX' {
    $line = "${label} IN ${dnstype} ${priority} ${target}"
  }
  else {
    warning('Incorrect DNS record type specified')
  }

  concat_fragment { "dns-static-${zone}+${title}.dnsstatic":
    content => $line,
  }


}
