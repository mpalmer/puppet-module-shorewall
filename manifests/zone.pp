# Define a shorewall zone and the interfaces which exist within it.
#
# Attributes:
#
#  * `name` (*namevar*)
#
#     The name of the zone being defined.  Must be a maximum of 5 characters
#     long.
#
#  * `type` (string; optional; default `undef`)
#
#     The specified type of the zone.  This can be any of the types defined
#     in `shorewall-zones`(5).  Think carefully when setting this parameter:
#     if you specify an IPv4 or IPv6-specific type (`ipv4`, `ipv6`,
#     `ipsec4`, `ipsec6`, `bport4`, `bport6`), then the zone will only be
#     defined in the shorewall or shorewall6 config, not both.  Which may
#     well be very, very bad.
#
#  * `interfaces` (hash; required)
#
#     A hash of `interface_name => interface_options` pairs, to denote the
#     interfaces to be included in this zone, along with the associated
#     options.
#
#  * `options` (string; optional; default `"-"`)
#
#     Specify a comma-separated list of options to apply to the zone.  The list
#     of available options is documented in `shorewall-zones`(5).
#
#  * `in_options` (string; optional; default `"-"`)
#
#     As per `options`, but only for packets coming into the machine from
#     the zone.
#
#  * `out_options` (string; optional; default `"-"`)
#
#     As per `options`, but only for packets coming out of the machine into
#     the zone.
#
define shorewall::zone(
		$type        = undef,
		$interfaces,
		$options     = "-",
		$in_options  = "-",
		$out_options = "-",
) {
	case $type {
		'ipv4','ipsec4','bport4': {
			$v4 = true
			$v6 = false
		}
		'ipv6','ipsec6','bport6': {
			$v4 = false
			$v6 = true
		}
		default: {
			$v4 = true
			$v6 = true
		}
	}

	if $v4 {
		if $type {
			$_type = $type
		} else {
			$_type = "ipv4"
		}

		bitfile::bit { "ipv4 zone ${name}":
			path    => "/etc/shorewall/zones",
			content => "${name} ${_type} ${options} ${in_options} ${out_options}";
		}
	}

	if $v6 {
		if $type {
			$_type = $type
		} else {
			$_type = "ipv6"
		}

		bitfile::bit { "ipv6 zone ${name}":
			path    => "/etc/shorewall6/zones",
			content => "${name} ${_type} ${options} ${in_options} ${out_options}";
		}
	}

	$interface_names = keys($interfaces)

	shorewall::underscore_interface { $interface_names:
		zone    => $name,
		options => $interfaces,
		v4      => $v4,
		v6      => $v6,
	}
}
