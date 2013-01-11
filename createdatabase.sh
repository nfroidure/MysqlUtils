#! /bin/sh
# Copyright 2012 Elitwork
# Distributed under the terms of the GNU General Public License v2

# Params
database=$1;
username=$2;

# Config
set -- $($(dirname $0)/credentials.sh);
user=$1;
password=$2;

# Help
if [ "$database" = "" ]; then
	echo "Create a new mysql database and give rights to a user if given";
	echo "$(basename $0) 1:database 2:username";
	exit;
fi

echo "Creating database $database"
mysql --user=${user} --password=${password} --execute="CREATE DATABASE $database";

if [ "$username" != "" ]; then
	echo "Giving rights to $username on her"
	mysql --user=${user} --password=${password} --execute="GRANT SELECT, INSERT, UPDATE, DELETE, CREATE VIEW, SHOW VIEW, LOCK TABLES ON $database . * TO '$username'@'localhost'; flush privileges;";
fi
