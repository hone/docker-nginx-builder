#!/bin/bash

source `dirname $0`/common.sh
source `dirname $0`/../common.sh

docker run -v $OUTPUT_DIR:/tmp/output -v $CACHE_DIR:/tmp/cache -e VERSION=1.8.0 -e STACK=$STACK-e hone/nginx-builder:$STACK
