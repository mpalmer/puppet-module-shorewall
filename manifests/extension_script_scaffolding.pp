# Create the necessary files and directories required to support the multi-file
# extension script support provided by `shorewall::extension_script`.
#
# NOTE: This class is not intended to be invoked directly, and does not form
# part of the public API for this module.
#

define shorewall::extension_script_scaffold_runner() {
	file { $name:
		ensure  => file,
		content => template("shorewall/etc/shorewall/extension_script"),
		owner   => "root",
		group   => "root",
		mode    => 0550,
		require => Noop["shorewall/installed"],
		before  => Noop["shorewall/configured"];
	}
}

define shorewall::extension_script_scaffold_phase() {
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
			mode    => 0750,
			require => Noop["shorewall/installed"],
			before  => Noop["shorewall/configured"];
	}

	shorewall::extension_script_scaffold_runner {
		[
			"/etc/shorewall/${name}",
			"/etc/shorewall6/${name}",
		]: ;
	}
}

class shorewall::extension_script_scaffolding {
	shorewall::extension_script_scaffold_phase {
		[
			"clear", "continue", "init", "isusable", "maclog", "postcompile",
			"refresh", "refreshed", "restored", "save", "scfilter", "start",
			"started", "stop", "stopped", "tcclear"
		]:
	}
}
