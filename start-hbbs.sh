#!/usr/bin/env sh

. /.env

cd /data

ENCRYPT_PARAMS=""
RELAY_PARAM=""

if [ "${ENCRYPTED_ONLY}" = "1" ];then
       ENCRYPT_PARAMS="-k _"
fi

if [ ! -z "${RELAY}" ];then
	RELAY_PARAM="-r ${RELAY}"
fi

/opt/rustdesk/hbbs ${RELAY_PARAM} ${ENCRYPT_PARAMS}

