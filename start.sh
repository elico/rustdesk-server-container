#!/usr/sh

env > /.env
chmod +x /.env

cd /data

pubkey="/data/id_ed25519.pub"
secret="/data/id_ed25519"

NO_PUB_KEY="1"
NO_SECRET="1"


if [ ! -z "${PUBLIC_KEY}" ];then
	if [ ! -z "${SECRET}" ];then
	        echo -n "${PUBLIC_KEY}" > "${pubkey}"
	        echo -n "${SECRET}" > "${secret}"
	else
		echo "Environment don't have a: SECRET variable"
	fi
else
	echo "Environment don't have a: PUBLIC_KEY variable"
fi

if [ -f "${pubkey}" ];then
	NO_PUB_KEY="0"
fi

if [ -f "${secret}" ];then
	NO_SECRET="0"
fi

echo "${NO_PUB_KEY}${NO_SECRET}" | grep "00"
if [ "$?" -gt "0" ];then
	echo "Generatiing a new key pair"
	KEY_PAIR=$(/opt/rustdesk/rustdesk-utils genkeypair )
	PUBLIC_KEY=$(echo "${KEY_PAIR}"|head -1 |awk '{print $3}')
	SECRET=$(echo "${KEY_PAIR}"|tail -1 |awk '{print $3}')
	echo -n "${PUBLIC_KEY}" > "${pubkey}"
	echo -n "${SECRET}" > "${secret}"
fi

/opt/rustdesk/rustdesk-utils validatekeypair $(cat ${pubkey}) $(cat ${secret})
if [ "$?" -gt "0" ];then
	echo "public key and secret are not valid, exiting"
	exit 1
fi

key=$(cat "${pubkey}")
echo "PUB Key: ${key}"
echo "${key}" > /public/pub-key

if [ ! -z "${IP}" ];then
	echo "${IP}" > /public/ip
fi

if [ ! -z "${DOMAIN}" ];then
	echo "${DOMAIN}" > /public/domain
fi

if [ ! -z "${HTTP_ADMIN_PASS}" ];then
	echo "${HTTP_ADMIN_PASS}" > /admin_pass
fi

if [ ! -z "${HTTP_ADMIN_USER}" ];then
	echo "${HTTP_ADMIN_USER}" > /admin_user
fi

if [ ! -z "${HTTP_PORT}" ];then
	echo "${HTTP_PORT}" > /http_port
fi

if [ -f "/public/ip" ];then
	echo "Generating Windows and Linux client agent installtion script"
	wanip="$( head -1 /public/ip)"
	if [ -f "/public/domain" ];then
		wanip="$( head -1 /public/domain)"
	fi
	WINDOWS_PS_INSTALLER_NAME="WindowsAgentAIOInstall.ps1"
	WINDOWS_PS_INSTALLER_TEMPLATE="/data/${WINDOWS_PS_INSTALLER_NAME}"

	sed -e "s|wanipreg|${wanip}|g" -e "s|keyreg|${key}|g" "${WINDOWS_PS_INSTALLER_TEMPLATE}" > "/public/${WINDOWS_PS_INSTALLER_NAME}"

	LINUX_SH_INSTALLER_NAME="linuxclientinstall.sh"
	LINUX_SH_INSTALLER_TEMPLATE="/data/${LINUX_SH_INSTALLER_NAME}"

	sed -e "s|wanipreg|${wanip}|g" -e "s|keyreg|${key}|g" "${LINUX_SH_INSTALLER_TEMPLATE}" > "/public/${LINUX_SH_INSTALLER_NAME}"
else
	echo "Couldn't generate installtion script since the file: /public/ip doesn't exist, you need to define the IP environment varialbe"
	echo "If you wish to override the IP with a domain name define both the IP and the DOMAIN variable"
fi

chmod +x /opt/rustdesk/gohttpserver
chmod +x /opt/rustdesk/hbbs
chmod +x /opt/rustdesk/hbbr

/usr/bin/supervisord -c /etc/supervisord.conf
