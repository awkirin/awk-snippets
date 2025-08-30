#!/bin/bash

get_server_status() {
    local url=$1
    local http_code
    http_code=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "User-Agent: AWKirin/uptime check" \
        --head \
        --connect-timeout 10 \
        "$url")
    echo "$http_code"
}

send_telegram_notification() {
    local text=$1
    curl -s -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "chat_id=${TG_CHAT_ID}&text=$text&parse_mode=html&disable_web_page_preview=true" \
        "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" > /dev/null
}

TG_TOKEN="${1}"
TG_CHAT_ID="${2}"

shift 2
SITES=("$@")


message=""
for site in "${SITES[@]}"; do
    status=$(get_server_status "$site")
    if [ "$status" -ne 200 ]; then
        domain=$(echo "$site" | sed 's|https://||')
        message+="----------------\n"
        message+="<b>site:</b> <a href='$domain'>$domain</a>\n"
        message+="<b>code:</b> $status\n"
    fi
done

if [ -n "$message" ]; then
    final_message="Notification from uptime\n$message"
    send_telegram_notification "$final_message"
fi