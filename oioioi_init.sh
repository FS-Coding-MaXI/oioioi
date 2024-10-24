#!/bin/bash
set -e
set -x

sudo /etc/init.d/ssh start

/sio2/oioioi/wait-for-it.sh -t 60 "oioioi_db:5432"

if [ "$1" == "--dev" ]; then
    ./manage.py migrate 2>&1 | tee /sio2/deployment/logs/migrate.log
    ./manage.py loaddata ../oioioi/extra/dbdata/default_admin.json
fi

exec ./manage.py supervisor --logfile=/sio2/deployment/logs/supervisor.log
