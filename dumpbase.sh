#! /bin/sh
# Copyright 2012-2013 Elitwork
# Distributed under the terms of the GNU General Public License v2

# Params
database=$1;
if [ "$2" != "" ]; then
	dumpfile=$2;
else
	dumpfile="/tmp/$database-dump.sql";
fi

# Config
set -- $($(dirname $0)/credentials.sh);
user=$1;
password=$2;

# Help
if [ "$database" = "" ]; then
	echo "Dump the given database to the given file"
	echo "$0 1:database 2:dumpfile"
	exit
fi

mysqldump --user=$user --password=$password $database > "$dumpfile"