#!/bin/sh
#
# Set volume to 90% on USB sound
#
CARD=1
TARGETS="Speaker
Mic"

for target in $TARGETS
do
  amixer -c $CARD sset "$target" on
  amixer -c $CARD sset "$target" 90%
done
