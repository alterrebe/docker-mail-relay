#! /usr/bin/env bash
set -eu

# dfg: Daemon Foreground
# Runs in foreground while a daemon is running and proxies signals to it.
# As a result, a daemonizing process can be run with supervisor

function display_help(){
    cat <<EOF
dfg: Daemon Foreground
Starts a daemon and runs in foreground while the daemon is active, and proxies signals.
As a result, a daemonizing process can be run with supervisor.

Usage: $(basename $0) <pidfile> <command...>
EOF
}
[ $# -lt 2 ] && display_help

# Arguments
pidfile="$1"
shift
command=$@

# Go foreground, proxy signals
function kill_app(){
    kill $(cat $pidfile)
    exit 0
}
trap "kill_app" SIGINT SIGTERM

# Launch daemon
$command
sleep 2

# Loop while the pidfile and the process exist
while [ -f $pidfile ] && kill -0 $(cat $pidfile) ; do
    sleep 0.5
done
exit 1000
