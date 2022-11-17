#!/bin/sh

set -eu

BUILDTIME=$(date -u +%Y/%m/%d-%H:%M:%S)

LDFLAGS="-X main.VERSION=NgTech -X main.BUILDTIME=${BUILDTIME}"
if [[ -n "${EX_LDFLAGS:-""}" ]]
then
	LDFLAGS="$LDFLAGS $EX_LDFLAGS"
fi

GOOS=linux GOARCH=amd64 go build -ldflags "$LDFLAGS" -o /build/gohttpserver-amd64
GOOS=linux GOARCH=arm64 go build -ldflags "$LDFLAGS" -o /build/gohttpserver-arm64
GOOS=linux GOARCH=arm GOARM=7 go build -ldflags "$LDFLAGS" -o /build/gohttpserver-arm

chmod +x /build/gohttpserver-amd64
chmod +x /build/gohttpserver-arm64
chmod +x /build/gohttpserver-arm

upx /build/gohttpserver-amd64
upx /build/gohttpserver-arm64
upx /build/gohttpserver-arm
