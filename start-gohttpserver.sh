#!/bin/sh

. /.env

PORT="8000"
ADMIN_USER="admin"
ADMIN_TOKEN="1234"

if [ -f "/http_port" ];then
	PORT=$(head -1 /http_port)
fi

if [ -f "/admin_user" ];then
	ADMIN_USER=$(head -1 /admin_user)
fi

if [ -f "/admin_pass" ];then
	ADMIN_TOKEN=$(head -1 /admin_pass)
fi

/opt/rustdesk/gohttpserver -r /public --port ${PORT} --auth-type http --auth-http ${ADMIN_USER}:${ADMIN_TOKEN}
