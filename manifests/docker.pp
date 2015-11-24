# Setup some extension scripts that will save and restore the Docker NAT
# rulesets on Shorewall restart.

class shorewall::docker {
	File {
		owner   => "root",
		group   => "root",
		mode    => 0444,
		require => Package["shorewall"],
	}
		
	file {
		"/etc/shorewall/init":
			ensure  => file,
			source  => "puppet:///modules/shorewall/etc/shorewall/init";
		"/etc/shorewall/stop":
			ensure  => file,
			source  => "puppet:///modules/shorewall/etc/shorewall/stop";
		"/etc/shorewall/start":
			ensure  => file,
			source  => "puppet:///modules/shorewall/etc/shorewall/start";
	}
}
