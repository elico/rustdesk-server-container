#!/usr/bin/env bash

echo "cleaning up"

rm -vrf build-dir/linux/{amd64,arm64,arm}

mkdir -p build-dir/linux/{amd64,arm64,arm}

#Download latest version of Rustdesk-server
RDLATEST=$(curl https://api.github.com/repos/rustdesk/rustdesk-server/releases/latest -s | grep "tag_name"| awk '{print substr($2, 2, length($2)-3) }')
wget "https://github.com/rustdesk/rustdesk-server/releases/download/${RDLATEST}/rustdesk-server-linux-amd64.zip" -O "build-dir/linux/amd64/rustdesk-server-linux-amd64.zip"
cd build-dir/linux/amd64/ && unzip rustdesk-server-linux-amd64.zip && cd -
chmod +x "build-dir/linux/amd64/amd64/hbbs"
chmod +x "build-dir/linux/amd64/amd64/hbbr"
chmod +x  "build-dir/linux/amd64/amd64/rustdesk-utils"
mv -v build-dir/linux/amd64/amd64/* build-dir/linux/amd64/

wget "https://github.com/rustdesk/rustdesk-server/releases/download/${RDLATEST}/rustdesk-server-linux-arm64v8.zip" -O "build-dir/linux/arm64/rustdesk-server-linux-arm64v8.zip"
cd build-dir/linux/arm64/ && unzip rustdesk-server-linux-arm64v8.zip && cd -
chmod +x "build-dir/linux/arm64/arm64v8/hbbs"
chmod +x "build-dir/linux/arm64/arm64v8/hbbr"
chmod +x  "build-dir/linux/arm64/arm64v8/rustdesk-utils"
mv -v build-dir/linux/arm64/arm64v8/* build-dir/linux/arm64/

wget "https://github.com/rustdesk/rustdesk-server/releases/download/${RDLATEST}/rustdesk-server-linux-armv7.zip" -O "build-dir/linux/arm/rustdesk-server-linux-armv7.zip"
cd build-dir/linux/arm/ && unzip rustdesk-server-linux-armv7.zip && cd -
chmod +x "build-dir/linux/arm/armv7/hbbs"
chmod +x "build-dir/linux/arm/armv7/hbbr"
chmod +x  "build-dir/linux/arm/armv7/rustdesk-utils"
mv -v build-dir/linux/arm/armv7/* build-dir/linux/arm/

echo "Downloaded rustdesk-server files"

rm -rf gohttpserver

git clone https://github.com/codeskyblue/gohttpserver

cp -v build-gohttp.sh gohttpserver/
cp -v Dockerfile-gohttp gohttpserver/Dockerfile

cd gohttpserver && docker build -t local-build/gohttpserver . && \
        docker run -it -v $(pwd):/build local-build/gohttpserver && \
	cd ..

cp gohttpserver/gohttpserver-amd64 build-dir/linux/amd64/gohttpserver
cp gohttpserver/gohttpserver-arm64 build-dir/linux/arm64/gohttpserver
cp gohttpserver/gohttpserver-arm build-dir/linux/arm/gohttpserver

echo "Compiled gohttpserver"

if [ -d "rustdeskinstall" ];then
	rm -rf rustdeskinstall
fi

git clone https://github.com/techahold/rustdeskinstall

cp rustdeskinstall/windowsclientID.ps1 ./
cp rustdeskinstall/clientinstall.ps1 ./
cp rustdeskinstall/WindowsAgentAIOInstall.ps1 ./

cp rustdeskinstall/linuxclientinstall.sh ./


#GOHTTPLATEST=$(curl https://api.github.com/repos/codeskyblue/gohttpserver/releases/latest -s | grep "tag_name"| awk '{print substr($2, 2, length($2)-3) }')
#wget "https://github.com/codeskyblue/gohttpserver/releases/download/${GOHTTPLATEST}/gohttpserver_${GOHTTPLATEST}_linux_amd64.tar.gz" -O "build-dir/linux/amd64/gohttpserver_${GOHTTPLATEST}_linux_amd64.tar.gz"
#cd build-dir/linux/amd64/ && tar -xf  gohttpserver_${GOHTTPLATEST}_linux_*.tar.gz && cd -

#wget "https://github.com/codeskyblue/gohttpserver/releases/download/${GOHTTPLATEST}/gohttpserver_${GOHTTPLATEST}_linux_arm64.tar.gz" -O "build-dir/linux/arm64/gohttpserver_${GOHTTPLATEST}_linux_arm64.tar.gz"
#cd build-dir/linux/arm64/ && tar -xf  gohttpserver_${GOHTTPLATEST}_linux_*.tar.gz && cd -

#chmod +x "build-dir/linux/arm/gohttpserver"
#chmod +x "build-dir/linux/arm64/gohttpserver"
#chmod +x "build-dir/linux/amd64/gohttpserver"

#upx "build-dir/linux/amd64/gohttpserver"
#upx "build-dir/linux/arm64/gohttpserver"
#upx "build-dir/linux/arm/gohttpserver"



