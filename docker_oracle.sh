#!/bin/bash

set -o pipefail

password="CHANGEME"


oracle-23() {
	echo "launch Oracle Database 23"
	docker run --name oracle -d -p 1523:1523 -e ORACLE_PASSWORD=$password -v oracle-volume:/u01/app/oracle/oradata gvenzl/oracle-free:23
	sleep 30
}

oracle-21() {
	echo "launch Oracle Database 21"
	docker run --name oracle -d -p 1521:1521 -e ORACLE_PASSWORD=$password -v oracle-volume:/u01/app/oracle/oradata gvenzl/oracle-xe:21
	sleep 30
}

oracle-18() {
	echo "launch Oracle Database 18"
	docker run --name oracle -d -p 1521:1521 -v oracle-volume:/u01/app/oracle/oradata gvenzl/oracle-xe:18
	echo "waiting 30s after launch for changing password to $password"
	sleep 30
	docker exec oracle resetPassword $password
}

oracle-11() {
	echo "launch Oracle Database 11"
	docker run --name oracle -d -p 1521:1521 -v oracle-volume:/u01/app/oracle/oradata gvenzl/oracle-xe:11
	echo "waiting 30s after launch for changing password to $password"
	sleep 30
	docker exec oracle resetPassword $password
}

oracle-latest() {
	echo "launch Oracle Database latest"
	docker run --name oracle -d -p 1521:1521 -v oracle-volume:/u01/app/oracle/oradata gvenzl/oracle-xe:latest
	echo "waiting 30s after launch for changing password to $password"
	sleep 30
	docker exec oracle resetPassword $password
}

oracle-del() {
	echo "stopping of oracle docker instance..."
	docker stop oracle
	echo "deletion of oracle docker instance..."
	docker rm oracle
	echo "done"
	exit 0
}

help () {
	echo "
	docker_oracle.sh <args>
	Lists of Arguments :
		--oracle-latest : Launch latest version of Oracle Database
		--oracle-23 : Launch v23 version of Oracle Database
		--oracle-21 : Launch v21 version of Oracle Database
		--oracle-18 : Launch v18 version of Oracle Database
		--oracle-11 : Launch v11 R2 verison of Oracle Database
		--oracle-del : deletion of Oracle Docker Instance
		--help : List all arguments on this script
	"
}

case $1 in
	--oracle-23)
		oracle-23;;
	--oracle-21)
		oracle-21;;
	--oracle-18)
		oracle-18;;
	--oracle-11)
		oracle-11;;
	--oracle-latest)
		oracle-latest;;
	--oracle-del)
		oracle-del;;
	--help)
		help;;
	*)
		echo "Unknown command; please use --help"
		exit 1
	;;
esac
