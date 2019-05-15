class shorewall::file::masq {
	bitfile { "/etc/shorewall/masq":
		owner   => "root",
		group   => "root",
		mode    => "0444",
		require => Noop["shorewall/installed"],
		before  => Noop["shorewall/configured"],
		notify  => Noop["shorewall/configured"],
	}

	shorewall::common_file_header_bit { "/etc/shorewall/masq": }

	bitfile::bit {
		"format for /etc/shorewall/masq":
			path    => "/etc/shorewall/masq",
			content => "#INTERFACE:DEST SOURCE ADDRESS PROTO PORT",
			ordinal => 10;
	}
}
