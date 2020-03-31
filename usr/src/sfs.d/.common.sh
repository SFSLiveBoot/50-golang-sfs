#!/bin/sh

: "${lbu:=/opt/LiveBootUtils}"
. "$lbu/scripts/common.func"

: "${dl_page:=https://golang.org/dl/}"
: "${tgz_fpat:=linux-amd64.tar.gz}"

latest_url() {
  curl -s "$dl_page" | grep -o "https://[^\"'[:space:]>]*${tgz_fpat}" | head -1
}

installed_ver() {
  "$DESTDIR/usr/local/go/bin/go" version | grep -o 'go[0-9][^[:space:]]*'
}

latest_ver() {
  : "${tgz_url:=$(latest_url)}"
  local latest_base="$(basename "$tgz_url")"
  echo "${latest_base%.$tgz_fpat}"
}

is_latest() {
  local installed_ver="$(installed_ver)"
  local latest_ver="$(latest_ver)"
  test "x$(installed_ver)" = "x$(latest_ver)" || {
    echo "Installed version not latest: '$installed_ver' -> '$latest_ver'" >&2
    return 1
  }
  echo "Latest version installed: '$latest_ver'" >&2
}
