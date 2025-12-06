#!/bin/bash
set -e

if [ -f /etc/cassandra/jvm.options ]; then
    sed -i 's/-XX:+UseConcMarkSweepGC/#-XX:+UseConcMarkSweepGC/' /etc/cassandra/jvm.options
    sed -i 's/-XX:CMSInitiatingOccupancyFraction=/#-XX:CMSInitiatingOccupancyFraction=/' /etc/cassandra/jvm.options
    sed -i 's/-XX:+UseCMSInitiatingOccupancyOnly/#-XX:+UseCMSInitiatingOccupancyOnly/' /etc/cassandra/jvm.options
    
    if ! grep -q "UseG1GC" /etc/cassandra/jvm.options; then
        echo "-XX:+UseG1GC" >> /etc/cassandra/jvm.options
        echo "-XX:MaxGCPauseMillis=200" >> /etc/cassandra/jvm.options
        echo "-XX:InitiatingHeapOccupancyPercent=45" >> /etc/cassandra/jvm.options
    fi
fi

if [ -f /usr/local/bin/docker-entrypoint.sh ]; then
    exec /usr/local/bin/docker-entrypoint.sh "$@"
elif [ -f /docker-entrypoint.sh ]; then
    exec /docker-entrypoint.sh "$@"
else
    exec /bin/bash -c "cassandra -f"
fi

