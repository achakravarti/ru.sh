#!/bin/sh

. src/log.sh
. src/os.sh
. src/su.sh

# Install shell scripts in src/ to /usr/local/src/ru.sh/
log_info 'installing shell scripts'
$SU mkdir -p /usr/local/src/ru.sh
$SU cp src/*.sh /usr/local/src/ru.sh
log_ok 'shell scripts installed'
