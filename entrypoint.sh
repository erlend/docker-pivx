#!/bin/sh

if [ -z "$1" ]; then
  set -- -help
fi

if [ "${1:0:1}" = "-" ]; then
  set -- dumb-init pivxd $@
fi

exec $@
