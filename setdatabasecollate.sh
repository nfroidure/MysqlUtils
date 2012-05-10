#! /bin/sh
# Copyright 2012 Elitwork
# Distributed under the terms of the GNU General Public License v2

# Init
cd /

# Config
MYSQL_USER="root"
MYSQL_PASSWORD=""

sitedatabase=$1
user=$2
verbose=$3

if [ "$sitedatabase" = "" ]; then
	echo "Set database collation as UTF8";
	echo "$0 : 1:sitedatabase 2:user 3:verbose(yes|no)";
	exit;
fi

if [ "$user" = "" ]; then
	user=$MYSQL_USER;
fi

if [ "$MYSQL_PASSWORD" = "" ]; then
	echo "Enter password of user : $user";
	stty -echo
	read password
	stty echo
else
	password=$MYSQL_PASSWORD
fi

if [ "$verbose" != "yes" ] && [ "$verbose" != "no" ]; then
	verbose="no"
fi

echo "# Setting UTF8 for database $sitedatabase"
mysql --user=${user} --password=${password} --execute="USE \`$sitedatabase\`;";
mysql --user=${user} --password=${password} --execute="ALTER DATABASE \`$sitedatabase\` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;";
tables=$(mysql --user=${user} --password=${password} --execute="SHOW TABLES FROM \`$sitedatabase\`;")

x=2
while [ "$x" != "" ]; do
	table=$(echo $tables | cut -d " " -f $x)
	if [ "$table" = "" ]; then
		break
	fi
	if [ "$verbose" = "yes" ]; then
		echo "## Converting table $table"
	fi
	mysql --user=${user} --password=${password} --execute="USE \`$sitedatabase\`; ALTER TABLE \`$table\` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;";
	mysql --user=${user} --password=${password} --execute="USE \`$sitedatabase\`; SHOW COLUMNS FROM \`$table\`;" | while read field type null key default extra; do
		if [ "$field" != "Field" ]; then
			if [ "$null" = "NO" ]; then
				null="NOT NULL"
			else
				null="NULL"
			fi
			if [ $(expr $type : ".*text") != "0" ] || [ $(expr $type : ".*blob") != "0" ] || [ $(expr $type : ".*char") != "0" ] || [ $(expr $type : "enum") != "0" ] || [ $(expr $type : "set") != "0" ]; then
				mysql --user=${user} --password=${password} --execute="USE \`$sitedatabase\`; ALTER TABLE \`$table\` CHANGE \`$field\` \`$field\` $type CHARACTER SET utf8 COLLATE utf8_general_ci $null;"
				if [ "$verbose" = "yes" ]; then
					echo "### Converting field $field ($type)"
				fi
			fi
		fi
	done
	x=$(expr $x + 1)
done
