# Define a shorewall tunnel.
#
# These allow shorewall to automatically setup rules to allow the tunnel
# encapsulation traffic to pass back and forth.
#
# Attributes:
#
#  * `type` (string; required)
#
#     Defines the type of tunnel.  This can be any of the types specified in
#     the `shorewall-tunnels` manpage.
#
#  * `zone` (string; required)
#
#     The zone through which the tunnel traffic (that is, the packets which
#     encapsulate the actual network traffic) passes.
#
#  * `gateway` (string; optional; default `undef`)
#
#     Specify the remote address to which the tunneled traffic is sent.  You
#     can only specify a single address (for a tunnel with multiple possible
#     gateways, use multiple `shorewall::tunnel` resources).  If left undefined,
#     then tunnel traffic to everywhere will be permitted.
#
define shorewall::tunnel(
		$type,
		$zone,
		$gateway = undef,
) {
	if $gateway == undef {
		$v4_gateway = "0.0.0.0/0"
		$v6_gateway = "::/0"
	} else {
		if is_fqdn($gateway) {
			$v4_gateway = $gateway
			$v6_gateway = $gateway
		} elsif is_v4($gateway) {
			$v4_gateway = $gateway
			$v6_gateway = undef
		} elsif is_v6($gateway) {
			$v4_gateway = undef
			$v6_gateway = $gateway
		} else {
			fail "Unknown format for gateway"
		}
	}

	if $v4_gateway {
		bitfile::bit { "shorewall::tunnel($name)":
			path    => "/etc/shorewall/tunnels",
			content => "${type} ${zone} ${v4_gateway}"
		}
	}

	if $v6_gateway {
		bitfile::bit { "shorewall6::tunnel($name)":
			path    => "/etc/shorewall6/tunnels",
			content => "${type} ${zone} ${v6_gateway}"
		}
	}
}
