# Install shorewall packages and perform fundamental configuration.
#
# Attributes:
#
#  * `v4_only` (boolean; optional; default `false`)
#
#     Set this to `true` if you don't want shorewall to be configured to
#     manage IPv6 firewall rules at *all*.  This should only be enabled if
#     you are actively IPv6-hostile: on a machine with no IPv6 connectivity,
#     managing IPv6 rules will have no adverse effect; on the other hand, if
#     you somehow end up with IPv6 connectivity but you're not managing your
#     IPv6 firewall rules, you can accidentally end up with a gaping goatse
#     of a firewall.
#
class shorewall(
		$v4_only = false
) {
	noop {
		"shorewall/installed": ;
		"shorewall/configured":
			require => Noop["shorewall/installed"];
	}

	package { "shorewall":
		before => Noop["shorewall/installed"]
	}

	file { "/etc/default/shorewall":
		ensure  => file,
		content => "# THIS FILE IS PUPPET MANAGED\n\nstartup=1\nINITLOG=/dev/null\nSAFESTOP=1\n",
		mode    => 0444,
		owner   => "root",
		group   => "root",
		require => Noop["shorewall/installed"],
		before  => Noop["shorewall/configured"],
	}

	service { "shorewall":
		ensure    => running,
		enable    => true,
		hasstatus => true,
		require   => [ Package["shorewall"],
		               Noop["shorewall/configured"],
		             ],
		subscribe => Noop["shorewall/configured"],
	}

	if !$v4_only {
		package { "shorewall6":
			before => Noop["shorewall/installed"]
		}

		file { "/etc/default/shorewall6":
			ensure  => file,
			content => "# THIS FILE IS PUPPET MANAGED\n\nstartup=1\nINITLOG=/dev/null\nSAFESTOP=1\n",
			mode    => 0444,
			owner   => "root",
			group   => "root",
			require => Noop["shorewall/installed"],
			before  => Noop["shorewall/configured"],
		}

		service { "shorewall6":
			ensure    => running,
			enable    => true,
			hasstatus => true,
			require   => [ Package["shorewall6"],
			               Noop["shorewall/configured"],
						    ],
			subscribe => Noop["shorewall/configured"],
		}
	}

	Bitfile {
		mode  => 0444,
		owner => "root",
		group => "root",
		require => Noop["shorewall/installed"],
		before  => Noop["shorewall/configured"],
		notify  => Noop["shorewall/configured"],
	}

	bitfile { ["/etc/shorewall/hosts",
	           "/etc/shorewall/interfaces",
	           "/etc/shorewall/masq",
	           "/etc/shorewall/policy",
	           "/etc/shorewall/rules",
	           "/etc/shorewall/tunnels",
	           "/etc/shorewall/zones"]:
	}

	if !$v4_only {
		bitfile { ["/etc/shorewall6/hosts",
		           "/etc/shorewall6/interfaces",
		           "/etc/shorewall6/masq",
		           "/etc/shorewall6/policy",
		           "/etc/shorewall6/rules",
		           "/etc/shorewall6/tunnels",
		           "/etc/shorewall6/zones"]:
		}
	}

	# Oh I'm going straight to hell for this one
	Bitfile::Bit {
		ordinal => 0,
		content => "# THIS FILE IS PUPPET MANAGED\n# LOCAL CHANGES WILL BE OVERRIDDEN\n",
	}

	bitfile::bit {
		"header for /etc/shorewall/hosts":
			path => "/etc/shorewall/hosts";
		"header for /etc/shorewall/interfaces":
			path => "/etc/shorewall/interfaces";
		"header for /etc/shorewall/masq":
			path => "/etc/shorewall/masq";
		"header for /etc/shorewall/policy":
			path => "/etc/shorewall/policy";
		"header for /etc/shorewall/rules":
			path => "/etc/shorewall/rules";
		"header for /etc/shorewall/tunnels":
			path => "/etc/shorewall/tunnels";
		"header for /etc/shorewall/zones":
			path => "/etc/shorewall/zones";
	}

	# Grrrrr
	bitfile::bit {
		"SECTION ALL for /etc/shorewall/rules":
			path => "/etc/shorewall/rules",
			content => "SECTION ALL",
			ordinal => 100;
		"SECTION ESTABLISHED for /etc/shorewall/rules":
			path => "/etc/shorewall/rules",
			content => "SECTION ESTABLISHED",
			ordinal => 200;
		"SECTION RELATED for /etc/shorewall/rules":
			path => "/etc/shorewall/rules",
			content => "SECTION RELATED",
			ordinal => 300;
		"SECTION NEW for /etc/shorewall/rules":
			path => "/etc/shorewall/rules",
			content => "SECTION NEW",
			ordinal => 600;
	}

	if $::shorewall_version >= 40513 {
		bitfile::bit {
			"SECTION INVALID for /etc/shorewall/rules":
				path => "/etc/shorewall/rules",
				content => "SECTION INVALID",
				ordinal => 400;
			"SECTION UNTRACKED for /etc/shorewall/rules":
				path => "/etc/shorewall/rules",
				content => "SECTION UNTRACKED",
				ordinal => 500;
		}
	}

	if !$v4_only {
		bitfile::bit {
			"header for /etc/shorewall6/hosts":
				path => "/etc/shorewall6/hosts";
			"header for /etc/shorewall6/interfaces":
				path => "/etc/shorewall6/interfaces";
			"header for /etc/shorewall6/masq":
				path => "/etc/shorewall6/masq";
			"header for /etc/shorewall6/policy":
				path => "/etc/shorewall6/policy";
			"header for /etc/shorewall6/rules":
				path => "/etc/shorewall6/rules";
			"header for /etc/shorewall6/tunnels":
				path => "/etc/shorewall6/tunnels";
			"header for /etc/shorewall6/zones":
				path => "/etc/shorewall6/zones";
		}

		bitfile::bit {
			"SECTION ALL for /etc/shorewall6/rules":
				path => "/etc/shorewall6/rules",
				content => "SECTION ALL",
				ordinal => 100;
			"SECTION ESTABLISHED for /etc/shorewall6/rules":
				path => "/etc/shorewall6/rules",
				content => "SECTION ESTABLISHED",
				ordinal => 200;
			"SECTION RELATED for /etc/shorewall6/rules":
				path => "/etc/shorewall6/rules",
				content => "SECTION RELATED",
				ordinal => 300;
			"SECTION NEW for /etc/shorewall6/rules":
				path => "/etc/shorewall6/rules",
				content => "SECTION NEW",
				ordinal => 600;
		}

		if $::shorewall_version >= 40513 {
			bitfile::bit {
				"SECTION INVALID for /etc/shorewall6/rules":
					path => "/etc/shorewall6/rules",
					content => "SECTION INVALID",
					ordinal => 400;
				"SECTION UNTRACKED for /etc/shorewall6/rules":
					path => "/etc/shorewall6/rules",
					content => "SECTION UNTRACKED",
					ordinal => 500;
			}
		}
	}

	shorewall::policy { "default reject-all-by-default":
		source => "all",
		dest   => "all",
		policy => "REJECT",
		log    => "info",
	}

	bitfile::bit {
		"ipv4 fw zone":
			path    => "/etc/shorewall/zones",
			content => "fw firewall",
			ordinal => 1;
		"ipv6 fw zone":
			path    => "/etc/shorewall6/zones",
			content => "fw firewall",
			ordinal => 1;
	}

	# Like you know what I want, shorewall...
	exec {
		"set IP_FORWARDING=Keep for shorewall":
			command => "/bin/sed -i 's/^IP_FORWARDING=.*$/IP_FORWARDING=Keep/' /etc/shorewall/shorewall.conf",
			unless  => "/bin/grep -q '^IP_FORWARDING=Keep$' /etc/shorewall/shorewall.conf",
			require => Noop["shorewall/installed"],
			before  => Noop["shorewall/configured"];
		"set IP_FORWARDING=Keep for shorewall6":
			command => "/bin/sed -i 's/^IP_FORWARDING=.*$/IP_FORWARDING=Keep/' /etc/shorewall6/shorewall6.conf",
			unless  => "/bin/grep -q '^IP_FORWARDING=Keep$' /etc/shorewall6/shorewall6.conf",
			require => Noop["shorewall/installed"],
			before  => Noop["shorewall/configured"];
	}
}
