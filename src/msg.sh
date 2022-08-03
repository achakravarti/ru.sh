# Code style following https://grymoire.com/Unix/Sh.html


# Prints a success message to stdout along with the timestamp, like so:
# [ OK ] Aug 03 09:12:33: sample message...
#
# The OK caption is padded for alignment and is displayed in green. The
# timestamp is printed in purple and follows the Linux kernel logging style. The
# message is suffixed with an ellipses.

msg_ok()
{
        printf '[\033[0;32m OK \033[0m] \033[0;35m%s\033[0m: %s...\n'   \
            "$(date +'%b %d %H:%M:%S')"                                 \
            "$1"
}


# Prints an informational message to stdout along with the timestamp, like so:
# [INFO] Aug 03 09:12:33: sample message...
#
# The INFO caption is displayed in blue. The timestamp is printed in purple and
# follows the Linux kernel logging style. The message is suffixed with an
# ellipses.

msg_info()
{
        printf '[\033[0;34mINFO\033[0m] \033[0;35m%s\033[0m: %s...\n'   \
            "$(date +'%b %d %H:%M:%S')"                                 \
            "$1"
}


# Prints a warning message to stdout along with the timestamp, like so:
# [WARN] Aug 03 09:12:33: sample message...
#
# The WARN caption is displayed in yellow. The timestamp is printed in purple
# and follows the Linux kernel logging style. The message is suffixed with an
# ellipses.

msg_warn()
{
        printf '[\033[1;33mWARN\033[0m] \033[0;35m%s\033[0m: %s...\n'   \
            "$(date +'%b %d %H:%M:%S')"                                 \
            "$1"
}


# Prints a failure message to stderr along with the timestamp, like so:
# [WARN] Aug 03 09:12:33: sample message...
#
# The WARN caption is displayed in yellow. The timestamp is printed in purple
# and follows the Linux kernel logging style. The message is suffixed with an
# ellipses following an indication that the script is exiting.

msg_fail()
{
        printf '[\033[1;31mFAIL\033[0m] \033[0;35m%s\033[0m: %s, exiting...\n'  \
            "$(date +'%b %d %H:%M:%S')"                                         \
            "$1"                                                                \
            2>&1

        exit 1
}
