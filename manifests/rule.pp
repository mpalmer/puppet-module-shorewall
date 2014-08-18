# Create a rule in a shorewall configuration.
#
# CAUTION: This type is *insane*.  You may find some comfort in other
# wrapper types, such as `shorewall::dnat` and `shorewall::accept`.
#
# Attributes:
#
#  * `section` (string; optional; default `"ALL"`)
#
#     Which "section" of the rules file to place this rule.  Valid values are
#     `"ALL"`, `"ESTABLISHED"`, `"RELATED"`, `"INVALID"`, `"UNTRACKED"`, and
#     `"NEW"`.  `"INVALID"` and `"UNTRACKED"` are only available if you are
#     running Shorewall 4.5.13 or later.
#
#  * `ordinal` (integer between 1 and 99; optional; default 50)
#
#     A means of ordering rules relatively within a section.  Since rules are
#     applied on a "first match" basis, you may sometimes have to adjust
#     the ordering of rules to achieve your desired outcome.
#
#  * `action` (string; required)
#
#     What to do with this rule.  There are so many possibilities for this,
#     you get to read the `shorewall-rules`(5) manpage to work out how to do
#     what you want to do.
#
#  * `source` (string; required)
#
#     Match traffic that comes from the specified location.  Again, see the
#     `shorewall-rules`(5) manpage for all the insanity you can apply in
#     here.
#
#  * `dest` (string; required)
#
#     Match traffic going to the specified location.  Manpage!
#
#  * `origdest` (string; optional; default `"-"`)
#
#     Just read the `shorewall-rules`(5) manpage.  I can't explain this.
#
#  * `proto` (string; optional; default `"-"`)
#
#     If defined, then only packets of the specified protocol will be
#     matched by this rule.  You must specify a protocol if you want to
#     specify source/destination ports.
#
#  * `sport` (string; optional; default `"-"`)
#
#     Only match traffic coming from the specified port(s).
#
#  * `dport` (string; optional; default `"-"`)
#
#     Only match traffic destined for the specified port(s).
#
#  * `v4_only` (boolean; optional; default `false`)
#
#     Specify that this firewall rule is *only* to be defined for IPv4. 
#     This sort of thing is usually determined heuristically, but there are
#     some cases where you want to be explicit about it.  Note that setting
#     this attribute overrides the normal heuristics, so you can end up
#     assploding shorewall if you (for example) use IPv6 addresses in a rule
#     marked `v4_only`.  So be careful.
#
#  * `v6_only` (boolean; optional; default `false`)
#
#     The IPv6 equivalent of `v4_only`.
#
define shorewall::rule(
		$section  = "NEW",
		$ordinal  = 50,
		$action,
		$source,
		$dest,
		$origdest = "-",
		$proto    = "-",
		$sport    = "-",
		$dport    = "-",
		$v4_only  = false,
		$v6_only  = false,
) {
	if $ordinal < 1 or $ordinal > 99 {
		fail "\$ordinal is out of range"
	}

	if $sport != "-" or $dport != "-" and $proto == "-" {
		fail "You must specify proto if you specify sport or dport"
	}

	if (contains_v4($source) or contains_v4($dest)) and (contains_v6($source) or contains_v6($dest)) {
		fail "You cannot mix IPv4 and IPv6 addresses in the same rule (source='${source}', dest='${dest}')"
	}

	if $v4_only and $v6_only {
		fail "A rule cannot both be v4_only and v6_only"
	}

	if $v4_only or contains_v4($source) or contains_v4($dest) {
		$v4 = true
		$v6 = false
	} elsif $v6_only or contains_v6($source) or contains_v6($dest) {
		$v4 = false
		$v6 = true
	} else {
		$v4 = true
		$v6 = true
	}

	case $section {
		"ALL": {
			$_ordinal = 100 + $ordinal
		}
		"ESTABLISHED": {
			$_ordinal = 200 + $ordinal
		}
		"RELATED": {
			$_ordinal = 300 + $ordinal
		}
		"INVALID": {
			$_ordinal = 400 + $ordinal
		}
		"UNTRACKED": {
			$_ordinal = 500 + $ordinal
		}
		"NEW": {
			$_ordinal = 600 + $ordinal
		}
		default: {
			fail "unknown section: $section"
		}
	}

	$content = "${action} ${source} ${dest} ${proto} ${dport} ${sport} ${origdest}"

	if $::shorewall_version >= 40513 or ($section != "INVALID" and $section != "UNTRACKED") {
		if $v4 {
			bitfile::bit { "shorewall::rule($name)":
				path    => "/etc/shorewall/rules",
				content => $content,
				ordinal => $_ordinal,
			}
		}

		if $v6 {
			bitfile::bit { "shorewall6::rule($name)":
				path    => "/etc/shorewall6/rules",
				content => $content,
				ordinal => $_ordinal,
			}
		}
	}
}
