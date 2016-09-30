#!/usr/bin/env bash
#
# Symlink any files ending in *.symlink into the $HOME directory

cd "$(dirname "$0")"
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
	printf "\r\033[2K  [\033[0;31m✗\033[0m] $1\n"
	echo ''
	exit
}

link_file() {
	local src=$1 dst=$2
	local overwrite= backup= skip=
	local action=

	if [ -f "$dst" -o -d "dst" -o -L "$dst" ]
	then
		if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
		then
			local current_src="$(readlink $dst)"
			if [ "$current_src" == "$src" ]
			then
				skip=true;
			else
				prompt="[s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all? "
				user "$dst ($(basename "$src")) already exists.\n\t$prompt"

				read -n 1 action

				case "$action" in
					o )
						overwrite=true;;
					O )
						overwrite_all=true;;
					b )
						backup=true;;
					B )
						backup_all=true;;
					s )
						skip=true;;
					S )
						skip_all=true;;
					* )
						;;
				esac
			fi
		fi

		overwrite=${overwrite:-$overwrite_all}
		backup=${backup:-$backup_all}
		skip=${skip:-$skip_all}

		if [ "$overwrite" == true ]
		then
			rm -rf "$dst"
			success "$dst (removed)"
		fi

		if [ "$backup" == "true" ]
		then
			mv "$dst" "${dst}.backup"
			success "$dst → ${dst}.backup"
		fi

		if [ "$skip" == "true" ]
		then
			success "$src (skipped)"
		fi
	fi

	if [ "$skip" != "true" ]
	then
		ln -s "$1" "$2"
		success "$1 → $2"
	fi
}

install_dotfiles() {
	info "Installing dotfiles"
	local overwrite_all=false backup_all=false skip_all=false

	for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
	do
		dst="$HOME/.$(basename "${src%.*}")"
		link_file "$src" "$dst"
	done

	echo ''
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

echo -e ''
echo -e "\033[1;34m  NuttyNeko's dotfiles  \033[0m"
echo -e "\033[0;34m  https://github.com/NuttyNeko/dotfiles  \033[0m"
echo -e ''

install_dotfiles
install_vundle
install_vim_plugins
install_zsh

configure_zsh
