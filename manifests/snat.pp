# Setup an arbitrary SNAT rule.
#
# This documentation should be read in conjunction with `shorewall-snat`(5).
#
# Attributes:
#
#  * `action` (string; required)
#
#     The exact form of SNAT action to perform.
#
#  * `source` (string; optional; default `"-"`)
#
#     If defined, only packets whose source address or incoming interface
#     matches the interface, address, or CIDR network range(s) listed will be
#     acted upon.
#
#  * `dest` (string; optional; default `"-"`)
#
#     If defined, only packets whose destination address or outgoing interface
#     matches the interface, address, or CIDR network range(s) listed will be
#     acted upon.
#
#  * `ordinal` (integer, optional; default 50)
#
#     Shorewall SNAT rules are matched in the order they are specified.  If
#     you have complicated NAT requirements, you may need to adjust
#     the ordinal of one or more of your `shorewall::snat` resources to get
#     the rules you need in the order you want.
#
define shorewall::snat(
		$action,
		$source  = "-",
		$dest    = "-",
		$proto   = undef,
		$port    = undef,
		$ordinal = 50,
) {
	bitfile::bit { "shorewall::masq(SNAT): ${name}":
		path    => "/etc/shorewall/snat",
		content => "${action} ${source} ${dest} ${proto} ${port}",
		ordinal => $ordinal,
	}
}
