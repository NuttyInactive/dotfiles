#!/usr/bin/env bash

cd "$(dirname "$0")"
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
	printf "\r\033[2K  [ \033[0;31m✗\033[0m ] $1\n"
	echo ''
	exit
}

install_dotfiles() {
	info "Installing bspwm and sxhkd dotfiles"

	if [ -z ${XDG_CONFIG_HOME+x} ]
	then
		fail "\$XDG_CONFIG_HOME is not set -- try reloading ~/.zshrc."
	fi

	if type bspwm > /dev/null 2>&1 && \
	   type sxhkd > /dev/null 2>&1 && \
	   type lemonbar > /dev/null 2>&1 && \
	   type lemonbuddy > /dev/null 2>&1
	then
		ls | grep -v 'zsh' | grep -v 'sh' | while read -r src
		do
			cp -frs $(pwd)/$src $XDG_CONFIG_HOME
			success "$(pwd)/$src → $XDG_CONFIG_HOME/$src"
		done
	else
		fail "bspwm, sxhkd, lemonbar, and lemonbuddy need to be installed"
	fi

	echo ''
}

install_dotfiles

