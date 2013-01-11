#! /bin/sh
#
# Get mysql credentials (useless and risky alone)
#
# Copyright 2012 Elitwork
# Distributed under the terms of the GNU General Public License v2

# Constants
CONF_PATH="../conf/";

# Config
if [ -f "$(dirname $0)/${CONF_PATH}database" ]; then
	read user password < "$(dirname $0)/${CONF_PATH}database"
fi

# Params
if [ "$1" != "" ]; then
	user=$1
fi
if [ "$2" != "" ]; then
	password=$1
fi

if [ "$user" = "" ]; then
	echo "Enter the mysql login :" > $(tty);
	read user
fi

if [ "$password" = "" ]; then
	echo "Enter the mysql password of user : $user" > $(tty);
	stty -echo
	read password
	stty echo
fi

echo "$user $password";
