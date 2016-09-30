if [ "$TMUX" = "" ]
then
    # Only start tmux in SSH sessions
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
    then
        # Force tmux to start with 256-color support
        # so that Powerline can be displayed properly
        exec tmux -2

        # tmux theme doesn't load until vim-airline loads
		vim -c q!
		clear
    fi
fi
