# Define an interface.  This is not designed to be used directly, and is not
# part of the stable API for this module.
#
# Attributes:
#
#  * `name` (*namevar*)
#
#     The name of the interface.
#
#  * `zone` (string; required)
#
#     The zone to put the interface in.
#
#  * `options` (hash; required)
#
#     A hash which contains a key named for $name, whose associated value is
#     the set of options to apply to this interface.
#
#  * `v4` (boolean; required)
#
#     Whether to define this interface in IPv4.
#
#  * `v6` (boolean; required)
#
#     Whether to define this interface in IPv6.
#
define shorewall::_interface(
		$zone,
		$options,
		$v4,
		$v6,
) {
	$opts = $options[$name]

	if $v4 {
		bitfile::bit { "shorewall::_interface($name)":
			path    => "/etc/shorewall/interfaces",
			content => "${zone} ${name} detect ${opts}\n";
		}
	}

	if $v6 {
		bitfile::bit { "shorewall6::_interface($name)":
			path    => "/etc/shorewall6/interfaces",
			content => "${zone} ${name} - ${opts}\n";
		}
	}
}
