#!/bin/bash
set -e

JVM_OPTS_FILE="/etc/cassandra/jvm.options"

if [ -f "$JVM_OPTS_FILE" ]; then
    sed -i.bak 's/^[^#]*-XX:+UseConcMarkSweepGC/#-XX:+UseConcMarkSweepGC/' "$JVM_OPTS_FILE"
    sed -i.bak 's/^[^#]*-XX:CMSInitiatingOccupancyFraction=/#-XX:CMSInitiatingOccupancyFraction=/' "$JVM_OPTS_FILE"
    sed -i.bak 's/^[^#]*-XX:+UseCMSInitiatingOccupancyOnly/#-XX:+UseCMSInitiatingOccupancyOnly/' "$JVM_OPTS_FILE"
    sed -i.bak 's/^[^#]*-XX:+CMSParallelRemarkEnabled/#-XX:+CMSParallelRemarkEnabled/' "$JVM_OPTS_FILE"
    sed -i.bak 's/^[^#]*-XX:+CMSParallelInitialMarkEnabled/#-XX:+CMSParallelInitialMarkEnabled/' "$JVM_OPTS_FILE"
    
    if ! grep -q "^[^#]*-XX:+UseG1GC" "$JVM_OPTS_FILE"; then
        echo "" >> "$JVM_OPTS_FILE"
        echo "# G1GC settings (replacing CMS)" >> "$JVM_OPTS_FILE"
        echo "-XX:+UseG1GC" >> "$JVM_OPTS_FILE"
        echo "-XX:MaxGCPauseMillis=200" >> "$JVM_OPTS_FILE"
        echo "-XX:InitiatingHeapOccupancyPercent=45" >> "$JVM_OPTS_FILE"
    fi
fi

if [ -f /usr/local/bin/docker-entrypoint.sh ]; then
    exec /usr/local/bin/docker-entrypoint.sh "$@"
elif [ -f /docker-entrypoint.sh ]; then
    exec /docker-entrypoint.sh "$@"
else
    exec cassandra -f
fi

