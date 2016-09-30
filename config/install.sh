#!/usr/bin/env bash

cd "$(dirname "$0")/config"
CONFIG_ROOT=$(pwd -P)

info() {
	printf "\r  [ \033[00;34m.\033[0m ] $1\n"
}

user() {
	printf "\r  [ \033[0;33m?\033[0m ] $1"
}

success() {
	printf "\r\033[2K  [ \033[00;32m✓\033[0m ] $1\n"
}

fail() {
	printf "\r\033[2K  [\033[0;31m✗\033[0m] $1\n"
	echo ''
	exit
}

install_bspwm() {
	info "Installing bspwm and sxhkd dotfiles"

	if command bspwm > /dev/null 2>&1 && \
	   command sxhkd > /dev/null 2>&1 && \
	   command lemonbar > /dev/null 2>&1 && \
	   command lemonbuddy_wrapper > /dev/null 2>&1
	then
		ls | grep -v '^.zsh' | grep -v '^.sh' | while read -r src
		do
			cp -rs $src $XDG_CONFIG_HOME
			success "$(pwd)$src → $XDG_CONFIG_HOME/$src"
		done
	else
		fail "bspwm, sxhkd, lemonbar, and lemonbuddy need to be installed"
	fi

	echo ''
}