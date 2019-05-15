class shorewall::file::snat {
	if 0 + $::shorewall_version >= 50014 {
		file { "/etc/shorewall/masq":
			ensure => absent,
			force  => true,
		}
	}

	bitfile { "/etc/shorewall/snat":
		owner   => "root",
		group   => "root",
		mode    => "0444",
		require => Noop["shorewall/installed"],
		before  => Noop["shorewall/configured"],
		notify  => Noop["shorewall/configured"],
	}

	shorewall::common_file_header_bit { "/etc/shorewall/snat": }

	bitfile::bit {
		"format for /etc/shorewall/snat":
			path    => "/etc/shorewall/snat",
			content => "#ACTION SOURCE DEST PROTO PORT",
			ordinal => 1;
	}
}
