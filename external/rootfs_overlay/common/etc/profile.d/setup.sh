#!/bin/sh
#
# Setup wizard that populates the crucial config files for a valid digipeater
# installation.

# Config files to be patched
AXPORTS="/etc/ax25/axports"
SOUNDMODEM="/etc/ax25/soundmodem.conf"
APRX="/etc/aprx.conf"

# Placeholders to be checked in config files
PH_CALLSIGN="%CALLSIGN%"
PH_LATITUDE="%LATITUDE%"
PH_LONGITUDE="%LONGITUDE%"
PH_APRSIS_PASSCODE="%APRSIS_PASSCODE%"

contains() {
  path="$1"
  string="$2"
  grep -q "$string" "$path"
}

replace() {
  path="$1"
  old="$2"
  new="$3"
  sed -e "s/$2/$3/" -i "$path"
}

error() {
  file="$1"
  echo "Error updating file: $file"
}

# If the last to-be-configured file is found to be already configured,
# retreat silently
contains "$APRX" "$CALLSIGN" || exit 0

read -p "Callsign: " callsign
read -p "Latitude: " latitude
read -p "Longitude: " longitude
read -p "APRS-IS Passcode: " passcode

echo "Updating $AXPORTS"
replace "$AXPORTS" "$PH_CALLSIGN" "$callsign" || error "$AXPORTS"

echo "Updating $SOUNDMODEM"
replace "$SOUNDMODEM" "$PH_CALLSIGN" "$callsign" || error "$SOUNDMODEM"

echo "Updating $APRX"
replace "$APRX" "$PH_CALLSIGN" "$callsign" || error "$APRX"
replace "$APRX" "$PH_LATITUDE" "$latitude" || error "$APRX"
replace "$APRX" "$PH_LONGITUDE" "$longitude" || error "$APRX"
replace "$APRX" "$PH_APRSIS_PASSCODE" "$passcode" || error "$APRX"

echo "All configuration files have been updated."
echo "Reboot the system for the changes to take effect."
