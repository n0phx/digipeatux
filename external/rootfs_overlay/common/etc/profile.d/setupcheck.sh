#!/bin/sh
#
# Informs the user on login if the APRS setup needs to be ran

APRX="/etc/aprx.conf"
CALLSIGN="%CALLSIGN%"

contains() {
  path="$1"
  string="$2"
  grep -q "$string" "$path"
}

if contains "$APRX" "$CALLSIGN"; then
  echo "Please execute the APRS setup wizard by issuing the command: sudo setup"
fi
