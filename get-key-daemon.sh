#!/usr/bin/env sh

. /.env

while [ -f "/.dockerenv" ];
do
	if [ ! -f "/public/pub-key" ];then
		pubname=$(find /data/ -type f -name "*.pub")
		key=$(cat "${pubname}")
		if [ -z "${key}" ];then
			sleep 1
		else		
			if [ -f "/data/id_ed25519" && -f "/data/id_ed25519.pub" ];then
				/opt/rustdesk/rustdesk-utils validatekeypair "$(cat /data/id_ed25519.pub)" "$(cat /data/id_ed25519)" 
				if [ "$?" -gt 0 ];then
					echo "Key pair not valid"
					exit 1
				fi
		    	
				echo "${key}" > /public/pub-key
				sleep 60
			else
				sleep 1
			fi
		fi
	else
		sleep 60
	fi

done
