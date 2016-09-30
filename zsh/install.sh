#!/usr/bin/env bash

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

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

install_zsh() {
	info "Installing Oh My Zsh"

	if [[ $SHELL == *"zsh"* ]]
	then
		success "zsh has been detected"
	else
		fail "zsh is not the default shell"
	fi

	if [ ! -d ~/.oh-my-zsh/ ]
	then
		if sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" > /dev/null 2>&1
		then
			success "Oh My Zsh has been installed"
		else
			fail "Oh My Zsh has failed to install"
		fi
	else
		success "Oh My Zsh has already been installed"
	fi

	echo ''
}

configure_zsh() {
	info "Configuring zsh"

	# store the path to the dotfiles in .zshrc in order
	# to source the other *.zsh files throughout the repo
	zsh_dotfiles=$DOTFILES_ROOT/zsh
	cp $zsh_dotfiles/zshrc.example $zsh_dotfiles/zshrc.symlink
	zsh_dotfiles=$(echo "export DOTFILES=$DOTFILES_ROOT" | sed -e 's/[\/&]/\\&/g')

	if sed -i "3s/.*/$zsh_dotfiles/" zsh/zshrc.symlink
	then
		success ".zshrc has successfully been configured"
	else
		fail "Failed to configure .zshrc"
	fi

	echo ''
}

install_zsh
configure_zsh
