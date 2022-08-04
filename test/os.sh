#!/bin/sh

. "$(dirname "0")/../src/log.sh"
. "$(dirname "0")/../src/os.sh"


export LOG_FILE=test.log


echo "OS_KERNEL = $OS_KERNEL"
echo "OS_DISTRO = $OS_DISTRO"
echo "OS_DISTRO_PRETTY = $OS_DISTRO_PRETTY"
echo "OS_VERSION = $OS_VERSION"
echo "OS_VERSION_PRETTY = $OS_VERSION_PRETTY"
