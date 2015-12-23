# Setup some extension scripts that will save and restore the Docker NAT
# rulesets on Shorewall restart.
#
class shorewall::docker {
	shorewall::extension_script {
		"docker_init":
			phase  => "init",
			source => "puppet:///modules/shorewall/etc/shorewall/docker/init";
		"docker_stop":
			phase  => "stop",
			source => "puppet:///modules/shorewall/etc/shorewall/docker/stop";
		"docker_start":
			phase  => "start",
			source => "puppet:///modules/shorewall/etc/shorewall/docker/start";
	}
}
