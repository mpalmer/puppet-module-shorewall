Facter.add("shorewall_version") do
	setcode do
		`shorewall version 2>/dev/null`.split('.')[0..2].inject(0) { |a, i| a*100 + i.to_i }
	end
end
