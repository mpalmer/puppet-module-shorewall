module Puppet::Parser::Functions
	newfunction(:is_fqdn, :type => :rvalue, :doc => "Returns true iff the variable passed to this function is a string containing an FQDN") do |args|
		args.length == 1 or raise Puppet::ParseError.new("is_fqdn: expecting 1 argument, got #{args.length}")

		item = args[0]
		item.is_a?(String) or return false
		!!(item =~ %r{^[a-zA-Z0-9.-]+$})
	end
end
