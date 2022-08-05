# Provides software package managment functionality. Depends on log.sh, os.sh
# and su.sh; be sure to source them before using this module.


# Return value from pkg_exists()

export RV


# Updates package lists and upgrades installed applications.

pkg_upgrade()
{
        log_info "upgrading packages, this may take a while"

        emsg="failed to upgrade packages"

        case "$OS_DISTRO" in
            alpine)
                $SU apk update | log_dump || log_fail "$emsg"
                $SU apk upgrade | log_dump || log_fail "$emsg"
                ;;
            arch)
                $SU pacman -Syu --noconfirm | log_dump || log_fail "$emsg"
                ;;
            freebsd)
                $SU pkg update | log_dump || log_fail "$emsg"
                $SU pkg upgrade -y | log_dump || log_fail "$emsg"
                ;;
            *)
                $SU apt update -y | log_dump || log_fail "$emsg"
                $SU apt upgrade -y | log_dump || log_fail "$emsg"
                ;;
        esac

        log_ok "upgraded packages"
}


# Checks whether a given package is already installed. We use RV to return
# whether or not the package specified through $1 exists.

pkg_exists()
{
        RV=1

        case "$OS_DISTRO" in
            alpine)
                apk info | grep -wq "$1" && RV=0
                ;;
            arch)
                pacman -Qi | tr -s ' ' | grep -wq "$1\$" && RV=0
                ;;
            freebsd)
                pkg info | grep -wq "$1" && RV=0
                ;;
            *)
                dpkg -l | grep -wq "$1" && RV=0
                ;;
        esac
}


# Installs a given package if not already installed, updating the packages lists
# first if required.

pkg_install()
{
        log_info "looking for package $1"

        omsg="package $1 already installed, skipping"
        pkg_exists "$1"
        [ "$RV" -eq 0 ] && log_ok "$omsg"; return

        log_info "package $1 not found, installing"

        emsg="failed to install package $1"
        case "$OS_DISTRO" in
            alpine)
                $SU apk update | log_dump || log_fail "$emsg"
                $SU apk add "$1" | log_dump || log_fail "$emsg"
                ;;
            arch)
                yay -S --needed --noconfirm "$1" | log_dump || log_fail "$emsg"
                ;;
            freebsd)
                $SU pkg install -y "$1" | log_dump || log_fail "$emsg"
                ;;
            *)
                $SU apt update -y "$1" | log_dump || log_fail "$emsg"
                $SU apt install -y "$1" | log_dump || log_fail "$emsg"
                ;;
        esac

        log_ok "installed package $1"
}


# Removes a given package if it is not already installed.

pkg_remove()
{
        log_info "looking for package $1"

        omsg="package $1 not installed, skipping"
        pkg_exists "$1"
        [ "$RV" -ne 0 ] && log_ok "$omsg"; return

        log_info "removing package $1"

        wmsg="failed to remove package $1"
        case "$OS_DISTRO" in
        alpine)
                $SU apk remove "$1" | log_dump || log_fail "$wmsg"
                ;;
        arch)
                yay -Rns --noconfirm "$1" | log_dump || log_warn "$wmsg"; return
                ;;
        freebsd)
                $SU pkg remove -y "$1" | log_dump || log_warn "$wmsg"; return
                ;;
        *)
                $SU apt remove -y "$1" | log_dump || log_fail "$wmsg"
                ;;
        esac

        log_ok "removed package $1"
}
