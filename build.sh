#!/bin/sh

workspace_dir=$1
output_dir=$2
cache_dir=$3

nginx_tarball="nginx-$VERSION.tar.gz"
ngx_mruby_dir="ngx_mruby"
ngx_mruby_git="https://github.com/matsumoto-r/$ngx_mruby_dir.git"

cd $cache_dir
if [ ! -f $nginx_tarball ]; then
    echo "Downloading $nginx_tarball"
    curl -s -O -L "http://nginx.org/download/nginx-$VERSION.tar.gz"
fi
if [ ! -d $ngx_mruby_dir ]; then
    echo "Cloning $ngx_mruby_git"
    git clone $ngx_mruby_git
    pushd $ngx_mruby_dir
    git submodule init
    git submodule update
    popd
else
    pushd $ngx_mruby_dir
    git submodule foreach git pull origin master
    popd
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
./configure --prefix=$workspace_dir/build --with-http_ssl_module --add-module=$ngx_mruby_src --add-module=$ngx_mruby_src/dependence/ngx_devel_kit
make
make install

cd $workspace_dir/build/sbin
strip nginx
mkdir -p $output_dir
tar ckzf $output_dir/nginx-$VERSION.tgz nginx
