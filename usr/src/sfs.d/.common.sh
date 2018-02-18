#!/bin/sh

: ${lbu:=/opt/LiveBootUtils}
. "$lbu/scripts/common.func"

: ${dl_page:=https://golang.org/dl/}
: ${tgz_fpat:=linux-amd64.tar.gz}

latest_url() {
  curl -s "$dl_page" | grep -o "https://[^\"'[:space:]>]*${tgz_fpat}" | head -1
}

installed_ver() {
  "$DESTDIR/usr/local/go/bin/go" version | grep -o 'go[0-9][^[:space:]]*'
}

latest_ver() {
  : ${tgz_url:=$(latest_url)}
  local latest_base="$(basename "$tgz_url")"
  echo "${latest_base%.$tgz_fpat}"
}
