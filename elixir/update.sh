#!/bin/bash
pushd /data || exit

for url in "$@"; do
    project_name=$(/project-name.py $url)
    mkdir -p  /data/$project_name/data
    mkdir -p  /data/$project_name/repo
    git clone "${url}" /data/$project_name/repo/
    pushd  /data/$project_name/repo/ || exit
    git pull
    popd ||exit

    pushd /usr/local/elixir/ || exit
    export LXR_DATA_DIR=/data/$project_name/data
    export LXR_REPO_DIR=/data/$project_name/repo
    python3 -u ./update.py
    popd || exit
done
popd || exit


/usr/sbin/apache2ctl -D FOREGROUND