#!/bin/sh

. "$(dirname "0")/../src/log.sh"


export LOG_FILE=test.log


log_ok "Hello, world!"
log_info "Hello, world!"
log_warn "Hello, world!"
log_dump "Hello, world!"
mount | log_dump
log_fail "Bye, world!"
