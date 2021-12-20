#!/bin/sh

: "${lbu:=/opt/LiveBootUtils}"
. "$lbu/scripts/common.func"

: "${dl_page:=https://go.dev/dl/}"
: "${tgz_fpat:=linux-amd64.tar.gz}"

latest_url() {
  test -z "$_latest_url" || { echo "$_latest_url"; return; }
  _latest_url="$(curl -L -s "$dl_page" | grep -Eo "(/dl/|https://)[^\"'[:space:]>]*${tgz_fpat}" | head -1)"
  case "$_latest_url" in
    https://*|http://*) ;;
    *) _latest_url="${dl_page%/dl/}$_latest_url" ;;
  esac
  echo "$_latest_url"
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
