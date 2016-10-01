#!/usr/bin/env sh

# Terminate already running bar instances
lemonbuddy_terminate noconfirm

# Launch lemon bar
lemonbuddy_wrapper top &

