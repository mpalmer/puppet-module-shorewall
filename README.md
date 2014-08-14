Management of IPv4 and IPv6 firewall rules via shorewall.  We transparently
identify rules which should go into shorewall vs shorewall6, and react
appropriately, attempting to keep policy in sync between the two protocol
families (something which is not often handled by firewalling tools, I'm
sorry to say).

The fundamental types are the `shorewall` class and the `shorewall::rule`
type.  The `shorewall` class is used to define the fundamental configuration
parameters which apply to the entire shorewall configuration (the zones,
interfaces, etc which make up the network topology of the machine), while
the `shorewall::rule` type is used to define individual rules.  See the
documentation in each individual class/type definition for details on how to
use each.

NOTE: This module does not implement all possible shorewall configuration
options.  I've only implemented those parts of shorewall which I find
useful, or which I can easily verify are correct.  If you would like further
support for something, please provide a patch, or at least let me know you
want it.
