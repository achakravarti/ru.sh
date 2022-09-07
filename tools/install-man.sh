#!/bin/sh

# Enable logging support
. "$(dirname "0")/src/log.sh"

# Determine host OS
. "$(dirname "0")/src/os.sh"

# Enable SU abstraction allowing root accout usage
ROOT_ALLOWED=0
. "$(dirname "0")/src/su.sh"

# Ensure /usr/local/share/man exists; on Linux systems this is a symlink to
# /usr/local/man
log_info 'checking man page directory'
if ! [ -d /usr/local/share/man ]; then
    log_info 'man directory not found, creating'
    if [ "$OS_KERNEL" = linux ]; then
	$SU mkdir -p /usr/local/man
	$SU ln -s /usr/local/man /usr/local/share/man
    else
	$SU mkdir -p /usr/local/share/man
    log_ok 'man directory created'
    fi
fi

# Ensure /usr/local/share/man/man3 exists
$SU mkdir -p /usr/local/share/man/man3

# Copy man pages to /usr/local/share/man/man3
log_info 'installing man pages'
src=$(find build/doc/ -type f -name '*.3.gz')
for x in $src; do
    $SU cp "$x" /usr/local/share/man/man3
done
log_ok 'man pages installed'

# Update man database
log_info 'updating man database'
$SU mandb
log_ok 'man database updated'

