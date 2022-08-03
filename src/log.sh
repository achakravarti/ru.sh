LOG_FILE=


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

        [ -n "$LOG_FILE" ] && printf '[ OK ] %s: %s...\n' "$ts" "$1"    \
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

        [ -n "$LOG_FILE" ] && printf '[INFO] %s: %s...\n' "$ts" "$1"    \
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

        printf '[\033[1;33mINFO\033[0m] \033[0;35m%s\033[0m: %s...\n' "$ts" "$1"

        [ -n "$LOG_FILE" ] && printf '[INFO] %s: %s...\n' "$ts" "$1"    \
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

        printf '[\033[1;33mINFO\033[0m] \033[0;35m%s\033[0m: %s...\n'   \
            "$ts"                                                       \
            "$1"                                                        \
            2>&1

        [ -n "$LOG_FILE" ] && printf '[INFO] %s: %s...\n' "$ts" "$1"    \
            >> "$LOG_FILE"

        exit 1
}


# Tees a message or the output of a command to both stdout and LOG_FILE without
# any additional formatting. In case of a message, it can be passed as an
# argument to this function, whereas the output of a command can be piped to
# this function. In case LOG_FILE is not set, then the output is displayed only
# on stdout.

log_raw()
{
        if [ -n "$LOG_FILE" ]
        then
                if [ -z "$1" ]
                then
                        cat | tee -a "$LOG_FILE"
                else
                        printf '%s\n' "$1"
                        printf '%s\n' "$1" >> "$LOG_FILE"
                fi
        else
                if [ -z "$1" ]
                then
                        cat
                else
                        printf '%s\n' "$1"
                fi
        fi
}
