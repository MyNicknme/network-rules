#!/bin/sh

LIST_DIR="/etc/pbr-lists"
TARGET_INTERFACE="KVN"

set_policy() {
    NAME="$1"
    FILE="$2"
    INTERFACE="$3"

    DOMAINS="$(grep -v '^#' "$FILE" | grep -v '^$' | tr '\n' ' ')"

    INDEX="$(uci show vpn-policy-routing | grep ".name='$NAME'" | sed -n 's/vpn-policy-routing.@policy\[\([0-9]*\)\].*/\1/p' | head -1)"

    if [ -z "$INDEX" ]; then
        uci add vpn-policy-routing policy
        INDEX="-1"
    fi

    uci set vpn-policy-routing.@policy[$INDEX].name="$NAME"
    uci set vpn-policy-routing.@policy[$INDEX].dest_addr="$DOMAINS"
    uci set vpn-policy-routing.@policy[$INDEX].interface="$INTERFACE"
}

set_policy "YouTube via VPN" "$LIST_DIR/youtube.list" "$TARGET_INTERFACE"
set_policy "OpenAI via VPN" "$LIST_DIR/openai.list" "$TARGET_INTERFACE"
set_policy "Streaming via VPN" "$LIST_DIR/streaming.list" "$TARGET_INTERFACE"

uci commit vpn-policy-routing
/etc/init.d/vpn-policy-routing restart
