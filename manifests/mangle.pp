# Create a 'mangle' rule in a shorewall configuration.
#
# CAUTION: This type is *insane*.  You may find some comfort in other
# wrapper types, such as `shorewall::dnat` and `shorewall::accept`.
#
# Attributes:
#
#  * `ordinal` (integer between 1 and 99; optional; default 50)
#
#     A means of ordering rules relatively within a section.  Since marking
#     is applied on a "last match" basis, you may sometimes have to adjust
#     the ordering of rules to achieve your desired outcome.
#
#  * `action` (string; required)
#
#     What to do with this rule.  There are so many possibilities for this,
#     you get to read the `shorewall-mangle`(5) manpage to work out how to do
#     what you want to do.
#
#  * `source` (string; required)
#
#     Match traffic that comes from the specified location.  Again, see the
#     `shorewall-mangle`(5) manpage for all the insanity you can apply in
#     here.
#
#  * `dest` (string; required)
#
#     Match traffic going to the specified location.  Manpage!
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
#
define shorewall::mangle(
		$ordinal    = 50,
		$action,
		$source,
		$dest,
		$proto      = "-",
		$sport      = "-",
		$dport      = "-",
		$v4_only    = false,
		$v6_only    = false,
) {
	if 0 + $::shorewall_version < 40600 {
		fail "shorewall::mangle only supported on Shorewall v4.6.0 or later"
	}

	if $ordinal < 1 or $ordinal > 99 {
		fail "\$ordinal is out of range (resource ${name})"
	}

	if ($sport != "-" or $dport != "-") and $proto == "-" {
		fail "You must specify proto if you specify sport or dport (resource ${name})"
	}

	if !$v4_only and !$v6_only and (contains_v4($source) or contains_v4($dest)) and (contains_v6($source) or contains_v6($dest)) {
		fail "You cannot mix IPv4 and IPv6 addresses in the same rule (source='${source}', dest='${dest}') (resource ${name})"
	}

	if $v4_only and $v6_only {
		fail "A rule cannot both be v4_only and v6_only (resource ${name})"
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

	$content = "${action} ${source} ${dest} ${proto} ${dport} ${sport}"

	if $v4 {
		bitfile::bit { "shorewall::mangle($name)":
			path    => "/etc/shorewall/mangle",
			content => $content,
			ordinal => $ordinal,
		}
	}

	if $v6 {
		bitfile::bit { "shorewall6::mangle($name)":
			path    => "/etc/shorewall6/mangle",
			content => $content,
			ordinal => $ordinal,
		}
	}
}
