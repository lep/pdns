# pdns

## What is pdns
pdns is a simple dns-server written in perl.
pdns stands for paranoia dns and it works accordingly: every dns-request is
forwarded to a random dns-server selected from a predefined list of dns-server.
Too speed up things every request is cached for an hour.

## State
pdns is usable. I use it myself but there is no install script.
You have to install the perl-packages yourself.
Also i absolutely made no code-tests.
But it works on atleast two systems: my Debian workstation and my
FreeBSD server. I also wrote an rc.d-script for pdns.

## Requirements
Perl 5
Net::DNS
Proc::PID::File
Proc::Daemon
List::Util
