#!/bin/sh

BASE="https://raw.githubusercontent.com/MyNicknme/network-rules/main/domains"
DIR="/etc/pbr-lists"

mkdir -p "$DIR"

wget -q -O "$DIR/youtube.list" "$BASE/proxy/youtube.list"
wget -q -O "$DIR/openai.list" "$BASE/proxy/openai.list"
wget -q -O "$DIR/streaming.list" "$BASE/proxy/streaming.list"
wget -q -O "$DIR/apple.list" "$BASE/direct/apple.list"
wget -q -O "$DIR/local_ru.list" "$BASE/direct/local_ru.list"

if [ -x /root/generate-vpr.sh ]; then
    /root/generate-vpr.sh
else
    /etc/init.d/vpn-policy-routing restart
fi
