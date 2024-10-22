#!/bin/bash
set -e
set -x

sudo apt install -y proot
sudo /etc/init.d/ssh start

/sio2/oioioi/wait-for-it.sh -t 60 "oioioi_db:5432"
/sio2/oioioi/wait-for-it.sh -t 0  "oioioi_web:8000"

mkdir -pv /sio2/deployment/logs/database

echo "LOG: Launching worker at `hostname`"
export FILETRACKER_URL="http://oioioi_web:9999"
exec python3 $(which twistd) --nodaemon --pidfile=/home/oioioi/worker.pid \
        -l /sio2/deployment/logs/worker`hostname`.log worker \
        --can-run-cpu-exec \
        -n worker`hostname` -c 2 oioioi_web \
        > /sio2/deployment/logs/twistd_worker.out \
        2> /sio2/deployment/logs/twistd_worker.err
