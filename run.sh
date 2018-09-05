#!/usr/bin/env bash
set -e
if [ -z "${TOMCAT_MANAGER_PASSWORD}" ]; then
    TOMCAT_MANAGER_PASSWORD=$(od -vN "20" -An -tx1 /dev/urandom | tr -d " \n")
    echo "TOMCAT_MANAGER_PASSWORD has not been defined. Generated password is: ${TOMCAT_MANAGER_PASSWORD}"
    export TOMCAT_MANAGER_PASSWORD
fi

/opt/confd/bin/confd -onetime -backend env

exec bin/catalina.sh run
