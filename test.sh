#!/bin/bash
url=${1:-https://google.com}
echo "#### Testing ${url} ..."
while [[ "$(curl -sLk --max-time 5 -o /dev/null -w %{http_code} ${url})" != "200" ]]; do echo "$(date)"; sleep 5; done
curl -sLk --max-time 5 -o /dev/null \
    -w "%{time_total} %{num_redirects} %{http_code} %{url_effective}\n" "${url}"
