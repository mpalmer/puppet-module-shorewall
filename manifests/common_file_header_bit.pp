define shorewall::common_file_header_bit() {
	bitfile::bit { "header for ${title}":
		path    => $title,
		ordinal => 0,
        content => "# THIS FILE IS PUPPET MANAGED\n# LOCAL CHANGES WILL BE OVERRIDDEN\n",
	}
}
