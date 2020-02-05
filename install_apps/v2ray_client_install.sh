#!/usr/bin/env bash

ip="$1"
port="$2"
id="$3"

if [ "$(uname)" == "Darwin" ]; then
	# MacOS
	HOMEBREW_NO_AUTO_UPDATE=1 brew tap v2ray/v2ray
	HOMEBREW_NO_AUTO_UPDATE=1 brew reinstall v2ray-core
	mv /usr/local/etc/v2ray/config.json /usr/local/etc/v2ray/config.json.bak
else
	# Ubuntu
	bash <(curl -L -s https://install.direct/go.sh)
	systemctl start v2ray
	mv /etc/v2ray/config.json /etc/v2ray/config.json.bak
fi

dir="$(dirname "$0")"

$dir/v2ray_setup.sh "$ip" "$port" "$id"

# To test if v2ray is doing its job properly, run:
# curl -4sSkL -x socks5h://127.0.0.1:1080 https://www.google.com
