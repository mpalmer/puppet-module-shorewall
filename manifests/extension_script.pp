# Create an extension scriptlet to be run during a phase of the shorewall
# firewall management process.
#
# Attributes:
#
#  * `title` (**namevar**; string; required)
#
#     What to name the file which stores the scriptlet.  This must contain
#     only letters, numbers, underscores, and hyphens.  The scriptlets will
#     be run in lexicographic order, if that's important to you.
#
#  * `phase` (string; required)
#
#     Which of the many, many phases of the shorewall configuration you
#     wish the script to be executed in.  Your options are anything listed
#     in http://shorewall.net/shorewall_extension_scripts.htm that doesn't
#     have to be written in Perl.
#
#  * `source` (string; optional; default `undef`)
#
#     A Puppet source definition to read the scriptlet from.  Exactly one
#     of `source` and `content` must be provided.
#
#  * `content` (string; optional; default `undef`)
#
#     The literal contents of the scriptlet.  Exactly one of `source` and
#     `content` must be provided.
#
define shorewall::extension_script(
		$phase,
		$source = undef,
		$content = undef,
) {
	include shorewall::extension_script_scaffolding

	if $title !~ /^[A-Za-z0-9_-]+$/ {
		fail("Invalid title: only letters, numbers, underscores and hyphens are allowed")
	}

	if $phase != "clear" and
	   $phase != "continue" and
	   $phase != "init" and
	   $phase != "isusable" and
	   $phase != "maclog" and
		$phase != "postcompile" and
	   $phase != "refresh" and
	   $phase != "refreshed" and
	   $phase != "restored" and
	   $phase != "save" and
		$phase != "scfilter" and
	   $phase != "start" and
	   $phase != "started" and
	   $phase != "stop" and
	   $phase != "stopped" and
	   $phase != "tcclear" {
		fail("Unknown phase '${phase}'")
	}

	if ($source == undef and $content == undef) or ($source and $content) {
		fail("Exactly one of source and content must be provided")
	}

	file {
		[
			"/etc/shorewall/${phase}.d/${name}",
			"/etc/shorewall6/${phase}.d/${name}",
		]:
			ensure  => file,
			source  => $source,
			content => $content,
			owner   => "root",
			group   => "root",
			mode    => "0550",
	}
}
