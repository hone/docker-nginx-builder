#!/bin/sh

workspace_dir=$1
output_dir=$2
cache_dir=$3

nginx_tarball="nginx-$VERSION.tar.gz"
ngx_mruby_dir="ngx_mruby"

cd $cache_dir
if [ ! -f $nginx_tarball ]; then
    echo "Downloading $nginx_tarball"
    curl -s -O -L "http://nginx.org/download/nginx-$VERSION.tar.gz"
fi

cd $workspace_dir
tar zxf $cache_dir/$nginx_tarball
cp -rf $cache_dir/$ngx_mruby_dir .

nginx_src="$workspace_dir/nginx-$VERSION"
ngx_mruby_src="$workspace_dir/$ngx_mruby_dir"

pushd $ngx_mruby_dir
./configure --with-ngx-src-root=$nginx_src
make build_mruby
make generate_gems_config
popd

cd $nginx_src
./configure --prefix=$workspace_dir/build --with-http_ssl_module --with-debug --add-module=$ngx_mruby_src --add-module=$ngx_mruby_src/dependence/ngx_devel_kit
make
make install

cd $workspace_dir/build/sbin
strip nginx
mkdir -p $output_dir
tar ckzf $output_dir/nginx-$VERSION.tgz nginx
