#!/bin/bash

set -e -x

script=$(readlink -f "$0")
cluster_dir=$(dirname "${script}")
topdir=$(dirname "${cluster_dir}")

cd "$topdir/dev/src/seahub"

for i in $(seq 1 2); do
    git diff v4.2.4-pro --name-only -- seahub/views seahub/utils | xargs -I {} cp -v --parents {} $cluster_dir/data/node$i/haiwen/seafile-server-latest/seahub/ || true
done

cd "$cluster_dir"
fab -P restart_seahub
