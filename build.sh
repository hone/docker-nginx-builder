#!/bin/sh

workspace_dir=$1
output_dir=$2
cache_dir=$3

nginx_tarball="nginx-$VERSION.tar.gz"

cd $cache_dir
if [ ! -f $nginx_tarball ]; then
    echo "Downloading $nginx_tarball"
    curl -s -O -L "http://nginx.org/download/nginx-$VERSION.tar.gz"
fi

cd $workspace_dir
tar zxf $cache_dir/$nginx_tarball
cd nginx-$VERSION
./configure --prefix=$workspace_dir/build --with-http_ssl_module
make
make install
cd $workspace_dir/build/sbin
mkdir -p $output_dir
tar ckzf $output_dir/nginx-$VERSION.tgz nginx
