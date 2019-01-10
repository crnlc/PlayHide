#!/bin/bash
[ -x /sbin/dhclient ] || exit 0

case $script_type in

up)
        dhclient -v tap3
        ;;
down)
        dhclient -r tap3
        ;;
esac