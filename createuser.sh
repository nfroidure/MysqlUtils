#! /bin/sh
# Copyright 2012 Elitwork
# Distributed under the terms of the GNU General Public License v2

# Params
newusername=$1
newuserpass=$2

# Config
set -- $($(dirname $0)/credentials.sh);
user=$1;
password=$2;

# Help
if [ "$newusername" = "" ]; then
	echo "Create a new mysql user";
	echo "$(basename $0) 1:newusername 2:newuserpass";
	exit;
fi

if [ "$newuserpass" = "" ]; then
	echo "Enter the password for the new user : $newusername";
	stty -echo
	read newuserpass
	stty echo
fi

echo "Creating mysql user : $newusername"
mysql --user=${user} --password=${password} --execute="GRANT USAGE ON * . * TO '$newusername'@'localhost' IDENTIFIED BY '$newuserpass'";
