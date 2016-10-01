if type ruby > /dev/null 2>&1
then
	PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
fi
