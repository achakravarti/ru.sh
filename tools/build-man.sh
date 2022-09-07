#!/bin/sh

# Enable logging functionality
. "$(dirname "0")/src/log.sh"

# Ensure pandoc and gzip binaries are available
log_info 'checking for required binaries'
pandoc -v >/dev/null 2>&1 || log_fail 'pandoc not found, install it first'
gzip -V >/dev/null 2>&1 || log_fail 'gzip not found, install it first'

# Ensure build directory exits
mkdir -p build/doc

# Generate compressed man page
log_info 'generating man pages'
pandoc doc/log.3.md -s -f markdown -t man -o build/doc/ru.sh:log.3
gzip -f build/doc/ru.sh:log.3
log_ok 'man pages generated'

