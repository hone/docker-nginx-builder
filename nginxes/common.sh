CACHE_DIR=${CACHE_DIR:-`pwd`/cache}

copy_ngx_mruby() {
    local ngx_mruby_dir="$CACHE_DIR/ngx_mruby"
    local source=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

    if [ -d $ngx_mruby_dir ]; then
        rm -rf $ngx_mruby_dir
    fi

    cp -a $source/../ngx_mruby $CACHE_DIR/
}

copy_ngx_mruby

echo "CACHE DIR:  $CACHE_DIR"
