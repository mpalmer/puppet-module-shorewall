module Puppet::Parser::Functions
	newfunction(:is_v6, :type => :rvalue, :doc => "Returns true iff the variable passed to this function is a string representing an IPv6 address or CIDR network") do |args|
		args.length == 1 or raise Puppet::ParseError.new("is_v6: expecting 1 argument, got #{args.length}")

		item = args[0]
		item.is_a?(String) or return false
		!!(item =~ %r{^[0-9a-fA-F:]+(/\d{1,3})?$})
	end
end
