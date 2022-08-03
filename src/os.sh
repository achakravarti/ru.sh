
# OS relarted identifiers populated by this script for use by client code. The
# identifiers ending with _STR are pretty forms mean for printing, whereas the
# others are meant to be easily compared.

export OS_KERNEL
export OS_DISTRO
export OS_DISTRO_STR
export OS_VERSION
export OS_VERSION_STR


# Mininum required OS versions; can be set by client code as required.

OS_VERSION_MIN_ALPINE=316
OS_VERSION_MIN_DEBIAN=11
OS_VERSION_MIN_FREEBSD=122
OS_VERSION_MIN_UBUNTU=2204


# Determines the OS kernel details. Currently, we support only current FreeBSD
# and Linux kernels as of 2022.

os__kernel()
{
        OS_KERNEL=$(uname -s | tr '[:upper:]' '[:lower:]')

        if [ "$OS_KERNEL" != freebsd ] && [ "$OS_KERNEL" != linux ]
        then
                msg_fail "unsupported kernel: $KERNEL_NAME"
        fi
}


# Determines the OS distribution. In case of FreeBSD, both kernel and
# distribution have the same name. For Linux, we rely on the /etc/os-release
# file (introduced by systemd) to determine the distribution name.

os__distro()
{
        if [ "$OS_KERNEL" = freebsd ]
        then
                OS_DISTRO=freebsd
                OS_DISTRO_STR=FreeBSD
                return
        fi

        _emsg='unable to determine Linux distribution'
        [ -f /etc/os-release ] || msg_fail "$_emsg"

        OS_DISTRO_STR=$(grep 'NAME' /etc/os-release     \
            | head -n 1                                 \
            | cut -d '=' -f 2                           \
            | tr -d '"')

        OS_DISTRO=$(echo $OS_DISTRO_STR                 \
            | cut -d ' ' -f 1                           \
            | tr '[:upper:]' '[:lower:]')

        _emsg="unsupported Linux distribution: $OS_DISTRO"
        [ "$OS_DISTRO" != alpine ]              \
            && [ "$OS_DISTRO" != arch ]         \
            && [ "$OS_DISTRO" != debian ]       \
            && [ "$OS_DISTRO" != ubuntu ]       \
            && msg_fail "$_emsg"
}


# Determines the OS version and whether it is greater than equal to the required
# minimum version. Relevant only to non-Arch Linux distributions since Arch
# Linux is a rolling release.

os__version()
{
        if [ "$OS_DISTRO" = freebsd ]
        then
                OS_VERSION_STR=$(uname -r)
                OS_VERSION=$(echo "$OS_VERSION_STR"             \
                    | cut -d '-' -f 1                           \
                    | tr -d '.')
        else
                OS_VERSION_STR=$(grep 'VERSION_ID' /etc/os-release      \
                    | tr -d '"'                                         \
                    | cut -d '=' -f 2)
                OS_VERSION=$(echo "$OS_VERSION_STR" | tr -d 'A-Z a-z ( ) .')
        fi

        _emsg="outdated Alpine Linux version: $OS_VERSTR"
                [ "$OS_VERSION_NUM" -lt $OS_VERSION_MIN_ALPINE ]        \
                    && msg_fail _emsg

        if [ "$OS_DISTRO" != 'arch' ]
        then
            case "$OS_DISTRO" in
                alpine ) _min=$OS_VERSION_MIN_ALPINE ;;
                debian ) _min=$OS_VERSION_MIN_DEBIAN ;;
                freebsd ) _min=$OS_VERSION_MIN_FREEBSD ;;
                ubuntu ) _min=$OS_VERSION_MIN_UBUNTU ;;
            esac

            _emsg="outdated $OS_DISTRO_STR version: $OS_VERSION_STR"
            [ "$OS_VERSION_NUM" -lt "$_min" ] && msg_fail _emsg
        fi

        msg_ok "detected $OS_DISTRO_NAME $OS_DISTRO_VER_STR"
}


# Determine the OS details if already not done so. We only need to check that
# the OS_VERNUM variable has been set because it possbile only after the other
# OS related variables have been set.

if [ -n "$OS_VERNUM" ]
then
        msg_info 'checking OS'
        os__kernel
        os__distro
        os__version
fi
