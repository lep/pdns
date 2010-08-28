#!/usr/bin/perl
use strict;
use warnings;

use Net::DNS::Nameserver;
use List::Util 'shuffle';
use Proc::Daemon;
use Proc::PID::File;

Proc::Daemon::Init;
if(Proc::PID::File->running()){
        exit 0;
}

my $ns=Net::DNS::Nameserver->new(
        LocalAddr       => '127.0.0.1',
        LocalPort       => '1953',
        ReplyHandler    => \&reply_handler,
);

my @ns;

my %cache;
my $ttl=3600;

my $res=Net::DNS::Resolver->new;

sub read_ips {   
        my $path=shift;
        open my $fh, "<", $path or die "Can't open config-file.";
        while(<$fh>){
                next if /^#/;  
                s/#.*$//;
                s/^\s+//;
                s/\s+$//;
                next unless $_;
                push @ns, $_;
        }
        close $fh;
}

sub update_entry {
        my ($qname, $qtype, $qclass)=@_;

        $res->nameservers(shuffle @ns);

        my $packet=$res->search($qname, $qtype, $qclass);
        if($packet){
                $cache{$qname}{$qtype}{$qclass}{update}=+time + $ttl;;
                $cache{$qname}{$qtype}{$qclass}{rr}=[map{
                        Net::DNS::RR->new("$qname $ttl $qclass $qtype ". $_->address)
                } $packet->answer];
                $cache{$qname}{$qtype}{$qclass}{error}=0;
        }else{
                $cache{$qname}{$qtype}{$qclass}{error}=$res->errorstring;
        }
}

sub reply_handler {
        my ($qname, $qclass, $qtype, $peerhost, $query, $conn) = @_;
        my ($rcode, @ans, @auth, @add);

        my $lp=$cache{$qname}{$qtype}{$qclass};
        if( !$lp || ($lp->{update} < +time) || $lp->{error} ){
                update_entry $qname, $qtype, $qclass;
        }
        $lp=$cache{$qname}{$qtype}{$qclass};

        if($lp->{error}){
                $rcode=$lp->{error};
        }else{
                @ans=@{$lp->{rr}};
        }
        return ($rcode, \@ans, \@auth, \@add, { aa => 1});
}

#TODO: make this better
read_ips '/usr/local/etc/pdns-nameserver';

$ns->main_loop;


