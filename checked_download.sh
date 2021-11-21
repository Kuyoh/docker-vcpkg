#!/bin/sh

sha256=$1
uri=$2
tmp_file=archive.tar.gz

if [ -z "$sha256" ]; then
    echo "checked_download.sh: error: no checksum provided"
    exit 1
fi

if [ -z "$uri" ]; then
    echo "checked_download.sh: error: no uri provided"
    exit 1
fi

curl -SL $uri --output $tmp_file
if [ $? -ne 0 ]; then
    echo "checked_download.sh: error: download failed ($uri)"
    exit 1
fi

echo "$sha256  $tmp_file" | sha256sum -c
if [ $? -ne 0 ]; then
    echo "checked_download.sh: error: checksum mismatch ($uri)"
    echo checked_download.sh: found $(sha256sum $tmp_file | cut -d' ' -f1), expected $sha256
    exit 1
fi

tar -xf $tmp_file
if [ $? -ne 0 ]; then 
    echo "checked_download.sh: error: failed to unpack ($uri)"
    exit 1
fi

rm $tmp_file
