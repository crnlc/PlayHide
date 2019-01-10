#!/bin/bash
# 
[ -x /sbin/resolvconf ] || exit 0
[ "$script_type" ] || exit 0
[ "$dev" ] || exit 0

split_into_parts()
{
	part1="$1"
	part2="$2"
	part3="$3"
}

[ -x /sbin/dhclient ] || exit 0

case $script_type in

up)
	NMSRVRS=""
	SRCHS=""
	for optionvarname in ${!foreign_option_*} ; do
		option="${!optionvarname}"
		echo "$option"
		split_into_parts $option
		if [ "$part1" = "dhcp-option" ] ; then
			if [ "$part2" = "DNS" ] ; then
				NMSRVRS="${NMSRVRS:+$NMSRVRS }$part3"
			elif [ "$part2" = "DOMAIN" ] ; then
				SRCHS="${SRCHS:+$SRCHS }$part3"
			fi
		fi
	done
	R=""
	[ "$SRCHS" ] && R="search $SRCHS
"
	for NS in $NMSRVRS ; do
        	R="${R}nameserver $NS
"
	done
	echo -n "$R" | /sbin/resolvconf -a "${dev}.openvpn"

        ;;
down)
	/sbin/resolvconf -d "${dev}.openvpn"
        ;;
esac