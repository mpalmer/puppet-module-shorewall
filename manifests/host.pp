# Define a set of addresses to be a "sub-zone".
#
# Don't use this unless you've looked at `shorewall-hosts`(5).  Madness
# awaits.
#
# Attributes:
#
#  * `zone` (string; required)
#
#     The name of the zone to add the hosts to.
#
#  * `interface` (string; required)
#
#     The interface on which the host will be accessed.
#
#  * `host` (string; required)
#
#     The address (with optional CIDR netmask) which should be matched.  Only
#     one address can be specified per resource; use multiple resources for
#     multiple addresses.
#
#  * `options` (string; optional; default `undef`)
#
#     A comma-separated list of options to apply to this host.
#
define shorewall::host(
		$zone,
		$interface,
		$host,
		$options = undef
) {
	is_v4($host) {
		bitfile::bit { "shorewall::host($name)":
			path    => "/etc/shorewall/hosts",
			content => "${zone} ${interface}:${host} ${options}"
		}
	} elsif is_v6($host) {
		bitfile::bit { "shorewall6::host($name)":
			path    => "/etc/shorewall6/hosts",
			content => "${zone} ${interface}:${host} ${options}"
		}
	} else {
		fail "Unknown format for host"
	}
}
