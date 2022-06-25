#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://storage.googleapis.com/dart-archive/channels

# https://storage.googleapis.com/dart-archive/channels/stable/release/2.9.1/sdk/dartsdk-macos-x64-release.zip.sha256sum
# https://storage.googleapis.com/dart-archive/channels/stable/release/2.9.1/sdk/dartsdk-linux-x64-release.zip.sha256sum

dl()
{
    local ver=$1
    local channel=$2
    local os=$3
    local arch=$4
    local archive_type=${4:-zip}
    local platform="${os}-${arch}"
    local url=$MIRROR/$channel/release/$ver/sdk/dartsdk-${platform}-release.zip.sha256sum
    printf "        # %s\n" $url
    printf "        %s: sha256:%s\n" $platform $(curl -sSLf $url | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    local channel=stable
    printf "  '%s':\n" $ver
    printf "    %s:\n" $channel
    dl $ver $channel macos x64
    dl $ver $channel linux x64
    dl $ver $channel linux ia32
    dl $ver $channel linux arm
    dl $ver $channel linux arm64
    dl $ver $channel windows ia32
    dl $ver $channel windows x64
}

dl_ver ${1:-2.17.5}
