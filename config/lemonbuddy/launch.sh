#!/usr/bin/env sh

# Terminate running instances
killall -q -9 lemonbuddy

# Launch lemon bar
lemonbuddy snowshoe &
lemonbuddy bottom &

