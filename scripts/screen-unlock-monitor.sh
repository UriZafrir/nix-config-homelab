#!/usr/bin/env bash
set -x
echo "Starting D-Bus monitor for screen unlock events..."

dbus-monitor --session "type='signal',interface='org.gnome.ScreenSaver',member='ActiveChanged'" | \
while read -r line; do
  if echo "$line" | grep -q "boolean false"; then
    echo "D-Bus signal received: $line" # Log every D-Bus signal
    xrandr --output HDMI-1 --brightness 0.3
  fi
done