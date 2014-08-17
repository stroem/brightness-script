#!/usr/bin/env bash

BRIGHTNESS_FILE="/sys/class/backlight/acpi_video0/brightness"
BRIGHTNESS_VALUE=`cat $BRIGHTNESS_FILE`

if [ $# -ne 1 ]; then
	echo "Usage: $0 <+/-10>"
	exit 0
fi

DEPS=`whereis bc | awk '{print $2}'`
if [ ! -z "$RET" ]; then
	echo "$?: bc is not installed, please installed it."
	exit 1
fi

GREP=`echo $1 | grep "[-+]"`
if [ $? -eq 0 ]; then
	NEW_VALUE=`echo "$BRIGHTNESS_VALUE$1" | bc`
	if [ $NEW_VALUE -gt 100 ]; then NEW_VALUE=100; fi
	if [ $NEW_VALUE -lt 0 ]; then NEW_VALUE=0; fi

	echo "Changing brightness to $NEW_VALUE"
else
	NEW_VALUE=$1
	echo "Setting brightness to $NEW_VALUE"
fi

sudo su -c "echo $NEW_VALUE > $BRIGHTNESS_FILE"
