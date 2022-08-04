# This module provides functionality for printing and logging messages. All
# other modules depend on this file; so be sure to source it.


# File where to log messages; this can be set by client code.

export LOG_FILE


# Logs a timestamped success message to both stdout and LOG_FILE, like so:
# [ OK ] Aug 03 09:12:33: sample message...
#
# The OK caption is padded for alignment and the timestamp follows the Linux
# kernel logging style. The message is suffixed with an ellipses. When printed
# to stdout, the caption is green and the timestamp is purple. If LOG_FILE is
# not set then the message is printed only to stdout.

log_ok()
{
        ts=$(date +'%b %d %H:%M:%S')

        printf '[\033[0;32m OK \033[0m] \033[0;35m%s\033[0m: %s...\n' "$ts" "$1"

        [ -z "$LOG_FILE" ]                              \
            || printf '[ OK ] %s: %s...\n' "$ts" "$1"   \
            >> "$LOG_FILE"
}


# Logs a timestamped informational message to both stdout and LOG_FILE, like so:
# [INFO] Aug 03 09:12:33: sample message...
#
# The timestamp follows the Linux kernel logging style. The message is suffixed
# with an ellipses. When printed to stdout, the caption is blue and the
# timestamp is purple. If LOG_FILE is not set then the message is printed only
# to stdout.

log_info()
{
        ts=$(date +'%b %d %H:%M:%S')

        printf '[\033[0;34mINFO\033[0m] \033[0;35m%s\033[0m: %s...\n' "$ts" "$1"

        [ -z "$LOG_FILE" ]                              \
            || printf '[INFO] %s: %s...\n' "$ts" "$1"   \
            >> "$LOG_FILE"
}


# Logs a timestamped warning message to both stdout and LOG_FILE, like so:
# [WARN] Aug 03 09:12:33: sample message...
#
# The timestamp follows the Linux kernel logging style. The message is suffixed
# with an ellipses. When printed to stdout, the caption is bold orange and the
# timestamp is purple. If LOG_FILE is not set then the message is printed only
# to stdout.

log_warn()
{
        ts=$(date +'%b %d %H:%M:%S')

        printf '[\033[1;33mWARN\033[0m] \033[0;35m%s\033[0m: %s...\n' "$ts" "$1"

        [ -z "$LOG_FILE" ]                              \
            || printf '[WARN] %s: %s...\n' "$ts" "$1"   \
            >> "$LOG_FILE"
}


# Logs a timestamped failure message to both stdout and LOG_FILE, like so:
# [FAIL] Aug 03 09:12:33: sample message...
#
# The timestamp follows the Linux kernel logging style. The message is suffixed
# with an ellipses and an indication that the script is exiting. When printed to
# stdout, the caption is bold red and the timestamp is purple. If LOG_FILE is
# not set then the message is printed only to stdout.

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


# Logs a message dump or the output of a command to both stdout and LOG_FILE,
# like so:
# [DUMP] Aug 03 09:12:33: message dump
#
# In case of a message, it can be passed as an argument to this function,
# whereas the output of a command can be piped to this function. When printed to
# stdout, the caption is cyan and the timestamp is purple. In case LOG_FILE is
# not set, then the output is displayed only on stdout.

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
