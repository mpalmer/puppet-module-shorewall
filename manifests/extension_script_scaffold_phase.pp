# Create the necessary files and directories required to support the multi-file
# extension script support provided by `shorewall::extension_script`.
#
# NOTE: This class is not intended to be invoked directly, and does not form
# part of the public API for this module.
#

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
			mode    => '0750',
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
