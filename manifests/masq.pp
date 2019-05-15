# Setup a masquerading rule, commonly referred to as "NAT" (although it's
# technically "source NAT").
#
# Attributes:
#
#  * `interface` (string; required)
#
#     The outgoing interface (or a comma-separated list of interfaces) for
#     traffic that is to be masqueraded.  This must be an interface you have
#     defined in a `shorewall::zone` resource.
#
#  * `source` (string; optional; default `undef`)
#
#     If defined, only packets whose source address matches the address or
#     CIDR network specified.  This can also be a comma-separated list of
#     same.
#
#  * `address` (string; optional; default `undef`)
#
#     The address (or range of addresses) to use as the source address to
#     translate the traffic to.  Messy.
#
#  * `ordinal` (integer, optional; default 50)
#
#     Shorewall masq rules are matched in the order they are specified.  If
#     you have complicated masquerading requirements, you may need to adjust
#     the ordinal of one or more of your `shorewall::masq` resources to get
#     the rules you need in the order you want.
#
define shorewall::masq(
		$interface,
		$source  = undef,
		$address = undef,
		$proto   = undef,
		$port   = undef,
		$ordinal = 50,
) {
	if 0 + $::shorewall_version >= 50014 {
		include shorewall::file::snat

		if $address {
			fail "Address syntax cannot be converted to newer Shorewall version format.  Please use shorewall::snat instead"
		}
	} else {
		include shorewall::file::masq
	}

	if $source {
		$_source = $source
	} else {
		if $address {
			$_source = "-"
		} else {
			$_source = ""
		}
	}

	if 0 + $::shorewall_version >= 50014 {
		bitfile::bit { "shorewall::masq(SNAT): ${name}":
			path    => "/etc/shorewall/snat",
			content => "MASQUERADE ${_source} ${interface} ${proto} ${port}",
			ordinal => $ordinal,
		}
	} else {
		bitfile::bit { "shorewall::masq: ${name}":
			path    => "/etc/shorewall/masq",
			content => "${interface} ${_source} ${address} ${proto} ${port}",
			ordinal => $ordinal,
		}
	}
}
