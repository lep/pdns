#!/bin/sh
. /etc/rc.subr
name="pdns"
rcvar=`set_rcvar`

command="/usr/local/bin/pdns"
command_interpreter="/usr/bin/perl"
pidfile="/var/run/${name}.pid"

load_rc_config $name
run_rc_command "$1"

