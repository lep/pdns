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

## Installation
Maybe this works
(FreeBSD)
	cp pdns-nameserver /usr/local/etc/
	cp pdns.pl /usr/local/bin/pdns
	cp pdns.sh /etc/rd.c/pdns
	cd /usr/ports/lang/perl5.10/ && make install clean
	cd /tmp/
	wget http://search.cpan.org/CPAN/authors/id/O/OL/OLAF/Net-DNS-0.66.tar.gz
	tar xf Net-DNS-0.66.tar.gz
	cd Net-DNS-0.66/ && perl Makefile.PL && make install
	cd /tmp/
	wget http://search.cpan.org/CPAN/authors/id/E/EC/ECALDER/Proc-PID-File-1.27.tar.gz
	tar xf Proc-PID-File-1.27.tar.gz
	cd  Proc-PID-File-1.27/ && perl Makefile.PL && make install
	cd /tmp/
	wget http://search.cpan.org/CPAN/authors/id/E/EH/EHOOD/Proc-Daemon-0.03.tar.gz
	tar xf Proc-Daemon-0.03.tar.gz
	cd Proc-Daemon-0.03/ && perl Makefile.PL && make install

You may also add `pdns_enable="YES"` in your /etc/rc.conf

## Requirements
* Perl 5
* Net::DNS
* Proc::PID::File
* Proc::Daemon
* List::Util
