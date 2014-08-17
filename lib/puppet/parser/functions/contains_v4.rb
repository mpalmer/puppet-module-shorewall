module Puppet::Parser::Functions
	newfunction(:contains_v4, :type => :rvalue, :doc => "Returns true iff the variable passed to this function is a string which contains something that looks like an IPv4 address or CIDR network") do |args|
		args.length == 1 or raise Puppet::ParseError.new("contains_v4: expecting 1 argument, got #{args.length}")

		item = args[0].dup
		item.is_a?(String) or return false
		# Strip off the leading zone identifier
		item.gsub!(/^[^:]+:/, '')
		!!(item =~ %r{\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(/\d{1,2})?})
	end
end
