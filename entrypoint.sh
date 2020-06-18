#!/bin/sh

if [ -z "$ETCD_NODE" ]
then
  echo "Missing ETCD_NODE env var"
  exit -1
fi

set -eo pipefail

echo "[gasbuddy/api-haproxy] booting container. ETCD: $ETCD_NODE"

function config_fail()
{
	echo "Failed to start due to config error"
	exit -1
}

confd -onetime -node "$ETCD_NODE"
exec confd -watch=true -node "$ETCD_NODE" &

echo "[gasbuddy/api-haproxy] Initial HAProxy config created. Starting haproxy and confd"
/usr/local/sbin/haproxy -f /usr/local/etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid
