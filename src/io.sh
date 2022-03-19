
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
