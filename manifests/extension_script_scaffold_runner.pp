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
		mode    => '0550',
		require => Noop["shorewall/installed"],
		before  => Noop["shorewall/configured"];
	}
}
