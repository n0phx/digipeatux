#!/bin/sh
#
# Display version of OS running

. /etc/version

echo "--------------------"
echo "$VERSION ($COMMIT)"
echo "--------------------"

