#! /bin/sh
# Copyright 2012-2013 Elitwork
# Distributed under the terms of the GNU General Public License v2

# Params
database=$1;
if [ "$2" != "" ]; then
	infile=$2;
else
	infile="/tmp/$database-dump.sql";
fi

# Config
set -- $($(dirname $0)/credentials.sh);
user=$1;
password=$2;

# Help
if [ "$database" = "" ]; then
	echo "Mount the given database from the given file"
	echo "$0 1:database 2:infile"
	exit
fi
if [ -f "$infile" ]; then
	mysql --user=$user --password=$password --host=localhost --database=$database < "$infile"
else
	echo "Infile not found : $infile."
fi