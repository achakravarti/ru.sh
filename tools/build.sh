#!/bin/sh

. src/log.sh
. src/os.sh
. src/su.sh
. src/pkg.sh


# Command line options; all set to false by default.
MAN=1
YES=1
HELP=1


# Parses command line options.
main_opts()
{
    while getopts 'myh' o; do
	case $o in
	    m) MAN=0
	       ;;
	    y) YES=0
	       ;;
	    h) HELP=0
	       ;;
	    *)
	       show_help 1
	       ;;
	esac
    done
}


# Performs main processing post command line option parsing.
main_exec()
{
    [ $HELP -eq 0 ] && show_help 0
    log_info 'starting build'

    [ $MAN -eq 0 ] && build_man

    log_ok 'build complete'
}


# Shows the help text.
show_help()
{
    echo 'build.sh -h: show this help text'
    echo 'build.sh -m: build man pages'
    echo 'build.sh -y: auto install missing binaries'
    exit "$1"
}


# Generates the man pages.
build_man()
{
    check_bin
    log_info 'generating man pages'

    mkdir -p build/doc
    pandoc doc/log.3.md -s -f markdown -t man -o build/doc/ru.sh:log.3
    gzip -f build/doc/ru.sh:log.3

    log_ok 'man pages generated'
}


# Checks whether gzip and pandoc are available. Currently we support only Arch
# Linux and FreeBSD.
check_bin()
{
    log_info 'checking required binaries'

    if [ $YES -eq 0 ]; then
	case "$OS_DISTRO" in
	    arch)
		pkg_install gzip
		pkg_install pandoc
		pkg_install pandoc-crossref
		;;
	    freebsd)
		pkg_install gzip
		pkg_install hs-pandoc
		pkg_install hs-pandoc-crossref
		pkg_install hs-pandoc-citeproc
		;;
	    *)
		log_fail "build script not supported for $OS_DISTRO"
		;;
	esac
    else
	case "$OS_DISTRO" in
	    arch)
		pkg_check gzip
		pkg_check pandoc
		pkg_check pandoc-crossref
		;;
	    freebsd)
		pkg_check gzip
		pkg_check hs-pandoc
		pkg_check hs-pandoc-crossref
		pkg_check hs-pandoc-citeproc
		;;
	    *)
		log_fail "build script not supported for $OS_DISTRO"
		;;
	esac
    fi
}


main_opts "$@"
main_exec
