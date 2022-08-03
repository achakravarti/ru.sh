
# Abstracted su command to be used by client code

export SU


# Flag to enable/disable running the script from the root account; this can be
# set by client code.

ROOT_ALLOWED=1


# Set SU to either sudo or doas depending on availability. If both are available
# then sudo takes higher precedence. If neither is avaiable then we abort.

if sudo -V >/dev/null 2>&1; then
        SU=sudo

elif doas -L >/dev/null 2>&1; then
        SU=doas

else
        log_fail 'sudo/doas not found'
fi


# Ensure that we are not running as root if ROOT_ALLOWED is set to false.

if [ "$ROOT_ALLOWED" -eq 1 ]
then
        id --version >/dev/null 2>&1 || log_fail 'id command not found'
        [ "$(id -u)" -eq 0 ] && log_fail 'running as root is dangerous'
fi
