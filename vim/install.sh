#!/usr/bin/env bash

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

install_vundle() {
	info "Installing Vundle"

	if [ ! -d ~/.vim/bundle/ ]
	then
		if git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null 2>&1
		then
			success "Vundle has been installed to ~/.vim/bundle/Vundle.vim"
		else
			fail "Vundle has failed to install"
		fi
	else
		success "Vundle has already been installed"
	fi

	echo ''
}

install_vim_plugins() {
	info "Installing Vim plugins"

	if vim +PluginInstall +qall > /dev/null 2>&1
	then
		success "Vim plugins have been installed"
	else
		fail "Vim plugins have failed to install"
	fi

	echo ''
}

install_vundle
install_vim_plugins
