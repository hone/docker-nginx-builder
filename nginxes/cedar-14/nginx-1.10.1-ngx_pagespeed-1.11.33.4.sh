#!/bin/bash

source `dirname $0`/common.sh
source `dirname $0`/../common.sh

docker run -v $OUTPUT_DIR:/tmp/output -v $CACHE_DIR:/tmp/cache -e VERSION=1.10.1 -e STACK=$STACK -e NGX_PAGESPEED_VERSION=1.11.33.4 hone/nginx-builder:$STACK