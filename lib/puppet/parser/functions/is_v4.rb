module Puppet::Parser::Functions
	newfunction(:is_v4, :type => :rvalue, :doc => "Returns true iff the variable passed to this function is a string representing an IPv4 address or CIDR network") do |args|
		args.length == 1 or raise Puppet::ParseError.new("is_v4: expecting 1 argument, got #{args.length}")

		item = args[0]
		item.is_a?(String) or return false
		!!(item =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(/\d{1,2})?$/)
	end
end
