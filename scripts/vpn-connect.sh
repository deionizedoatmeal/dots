#!/bin/bash

# sudo openconnect --protocol=gp --user=ibania remoteaccess.colgate.edu
{
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo openconnect --protocol=gp remoteaccess.colgate.edu
ibania
***REMOVED***
SplitTunnel
EOF
} </dev/null &>/dev/null &
