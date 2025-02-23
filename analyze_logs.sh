#!/bin/bash

cat <<EOL > access.log
192.168.1.1 - - [28/Jul/2024:12:34:56 +0000] "GET /index.html HTTP/1.1" 200 1234
192.168.1.2 - - [28/Jul/2024:12:35:56 +0000] "POST /login HTTP/1.1" 200 567
192.168.1.3 - - [28/Jul/2024:12:36:56 +0000] "GET /home HTTP/1.1" 404 890
192.168.1.1 - - [28/Jul/2024:12:37:56 +0000] "GET /index.html HTTP/1.1" 200 1234
192.168.1.4 - - [28/Jul/2024:12:38:56 +0000] "GET /about HTTP/1.1" 200 432
192.168.1.2 - - [28/Jul/2024:12:39:56 +0000] "GET /index.html HTTP/1.1" 200 1234
EOL

create_report() {
    logfile="access.log"
    reportfile="report.txt"

    total_requests=$(wc -l < "$logfile")
    echo "Общее количество запросов: $total_requests" > "$reportfile"

    unique_ips=$(awk '{print $1}' "$logfile" | sort | uniq | wc -l)
    echo "Количество уникальных IP-адресов: $unique_ips" >> "$reportfile"

    echo "Количество запросов по методам:" >> "$reportfile"
    awk -F'"' '{print $2}' "$logfile" | awk '{print $1}' | sort | uniq -c | while read count method; do
        echo "$method: $count" >> "$reportfile"
    done

    popular_url=$(awk -F'"' '{print $2}' "$logfile" | awk '{print $2}' | sort | uniq -c | sort -nr | head -n 1)
    echo "Самый популярный URL: $popular_url" >> "$reportfile"
}

create_report

cat report.txt
