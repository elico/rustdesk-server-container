#!/usr/bin/env sh

. /.env
cd /data

ENCRYPT_PARAMS=""

if [ "${ENCRYPTED_ONLY}" = "1" ];then
       ENCRYPT_PARAMS="-k _"
fi

/opt/rustdesk/hbbr ${ENCRYPT_PARAMS}
