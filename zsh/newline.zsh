# precmd() hook
#
# Print a new line before the next prompt if the last command
# entered was not 'clear'.

precmd() {
	if [[ $(fc -ln | tail -n 1) != "clear" ]]
	then
		print ""
	fi
}

