# Create the necessary files and directories required to support the multi-file
# extension script support provided by `shorewall::extension_script`.
#
# NOTE: This class is not intended to be invoked directly, and does not form
# part of the public API for this module.
#

define shorewall::extension_script_scaffold_oneshot() {
	file {
		[
			"/etc/shorewall/${name}.d",
			"/etc/shorewall6/${name}.d",
		]:
			ensure  => directory,
			purge   => true,
			recurse => true,
			owner   => "root",
			group   => "root",
			mode    => 0750;
		[
			"/etc/shorewall/${name}",
			"/etc/shorewall6/${name}",
		]:
			ensure => file,
			source => "puppet:///modules/shorewall/etc/shorewall/extension_script",
			owner  => "root",
			group  => "root",
			mode   => 0550;
	}
}

class shorewall::extension_script_scaffolding {
	shorewall::extension_script_scaffold_oneshot {
		[
			"clear", "continue", "init", "initdone", "isusable", "maclog",
			"postcompile", "refresh", "refreshed", "restored", "save",
			"scfilter", "start", "started", "stop", "stopped", "tcclear"
		]:
	}
}
