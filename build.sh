#!/bin/sh

workspace_dir=$1
output_dir=$2
cache_dir=$3

nginx_tarball="nginx-$VERSION.tar.gz"
ngx_mruby_dir="ngx_mruby"
ngx_mruby_version=$(grep -oP '(?<=MODULE_VERSION ")(\d+\.\d+\.\d+)(?=")' $cache_dir/$ngx_mruby_dir/src/http/ngx_http_mruby_module.h | tr -d '\n')
ngx_pagespeed_dir="ngx_pagespeed"

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

mkdir -p $ngx_pagespeed_dir
pushd $ngx_pagespeed_dir
curl -O -f -L -sS https://ngxpagespeed.com/install
chmod +x install
./install -b $workspace_dir/$ngx_pagespeed_dir -m -v $NGX_PAGESPEED_VERSION
popd

cd $nginx_src
./configure --prefix=$workspace_dir/build --with-http_ssl_module --with-debug --add-module=$ngx_mruby_src --add-module=$ngx_mruby_src/dependence/ngx_devel_kit --add-dynamic-module=$workspace_dir/$ngx_pagespeed_dir/ngx_pagespeed-$NGX_PAGESPEED_VERSION-beta
make
make install

cd $workspace_dir/build/sbin
strip nginx
mkdir -p $output_dir
tar ckzf $output_dir/nginx-$VERSION-ngx_mruby-$ngx_mruby_version.tgz nginx

cd $workspace_dir/build
tar ckzf $output_dir/ngx_pagespeed-$NGX_PAGESPEED_VERSION.tgz modules/ngx_pagespeed.so
