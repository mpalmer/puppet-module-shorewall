# Create the necessary files and directories required to support the multi-file
# extension script support provided by `shorewall::extension_script`.
#
# NOTE: This class is not intended to be invoked directly, and does not form
# part of the public API for this module.
#

class shorewall::extension_script_scaffolding {
	shorewall::extension_script_scaffold_phase {
		[
			"clear", "continue", "init", "isusable", "maclog", "postcompile",
			"refresh", "refreshed", "restored", "save", "scfilter", "start",
			"started", "stop", "stopped", "tcclear"
		]:
	}
}
