#!/bin/sh
# SPDX-License-Identifier: BSD-2-Clause
#
# ru.sh/src/log.sh -- logging interface
# Copyright (c) 2022 Abhishek Chakravarti <abhishek@taranjali.org>
# See ru.sh:log(3) for documentation.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


# File where to log messages; this can be set by client code.
export LOG_FILE


# Logs OK message to stdout.
log_ok()
{
        ts=$(date +'%b %d %H:%M:%S')

        printf '[\033[0;32m OK \033[0m] \033[0;35m%s\033[0m: %s...\n' "$ts" "$1"

        [ -z "$LOG_FILE" ]                              \
            || printf '[ OK ] %s: %s...\n' "$ts" "$1"   \
            >> "$LOG_FILE"
}


# Logs INFO message to stdout.
log_info()
{
        ts=$(date +'%b %d %H:%M:%S')

        printf '[\033[0;34mINFO\033[0m] \033[0;35m%s\033[0m: %s...\n' "$ts" "$1"

        [ -z "$LOG_FILE" ]                              \
            || printf '[INFO] %s: %s...\n' "$ts" "$1"   \
            >> "$LOG_FILE"
}


# Logs WARN message to stdout.
log_warn()
{
        ts=$(date +'%b %d %H:%M:%S')

        printf '[\033[1;33mWARN\033[0m] \033[0;35m%s\033[0m: %s...\n' "$ts" "$1"

        [ -z "$LOG_FILE" ]                              \
            || printf '[WARN] %s: %s...\n' "$ts" "$1"   \
            >> "$LOG_FILE"
}


# Logs FAIL message to stdout.
log_fail()
{
        ts=$(date +'%b %d %H:%M:%S')

        printf                                                          \
            '[\033[1;31mFAIL\033[0m] \033[0;35m%s\033[0m: %s...\n'      \
            "$ts"                                                       \
            "$1"                                                        \
            2>&1

            [ -z "$LOG_FILE" ]                                  \
                || printf '[FAIL] %s: %s...\n' "$ts" "$1"       \
                >> "$LOG_FILE"

        exit 1
}


# Logs output of command.
# TODO: implementation stiill buggy
log_dump()
{
        ts=$(date +'%b %d %H:%M:%S')

        if [ -z "$LOG_FILE" ]
        then
                if [ -z "$1" ]
                then
                        cat
                else
                        printf                                                  \
                            '[\033[0;36mDUMP\033[0m] \033[0;35m%s\033[0m:\n'    \
                            "$ts"
                        printf '%s\n' "$1"
                fi
        else
                if [ -z "$1" ]
                then
                        cat | tee -a "$LOG_FILE"
                else
                        printf                                                  \
                            '[\033[0;36mDUMP\033[0m] \033[0;35m%s\033[0m:\n'    \
                            "$ts"
                        printf '%s\n' "$1"
                        printf '[DUMP] %s:\n' "$ts" >> "$LOG_FILE"
                        printf '%s\n' "$1" >> "$LOG_FILE"
                fi
        fi
}
