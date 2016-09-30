#!/usr/bin/env bash

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
	printf "\r\033[2K  [ \033[0;31m✗\033[0m ] $1\n"
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

echo -e ''
echo -e "\033[1;34m  NuttyNeko's dotfiles  \033[0m"
echo -e "\033[0;34m  https://github.com/NuttyNeko/dotfiles  \033[0m"
echo -e ''

install_dotfiles

# find the installers and run them iteratively
find . -name install.sh | while read installer ; do sh -c "${installer}" ; done
