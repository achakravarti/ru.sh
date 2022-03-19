
# r_ok - displays OK message
r_ok() {
	printf '[\033[0;32m  OK\033[0m] %s...\n' "$1"
}


# r_warn - displays warning message
r_warn() {
	printf '[\033[0;33mWARN\033[0m ]%s...\n' "$1"
}


# r_fail - displays failure message and exits
r_fail() {
	printf '[\033[0;31mFAIL\033[0m] %s.\n' "$1"
	exit
}


# r_yn - prompts user for y/N input
r_yn() {
	printf '[\033[0;34m INP\033[0m] %s (y/N)?: ' "$1"
	read -r _inp

	if [ -z "$_inp" ] ; then
		r_ok "Operation skipped"
		return 1
	fi 

	if [ "$_inp" != "y" ] && [ "$_inp" != "Y" ] ; then
		r_ok "Operation skipped"
		return 1
	fi
	
	return 0
}


# r_put - appends line of text to a file without a newline
r_put() {
	printf '%b' "$2" >> "$1"
}


# r_putn - appends line of text to a file with a newline
r_putn() {
	printf '%b\n' "$2" >> "$1"
}

