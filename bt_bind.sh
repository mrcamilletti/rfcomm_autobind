#!/bin/bash
MAC=$1
HCIN=$2

HCIF=/dev/rfcomm$2

if [[ -e $HCIF ]]; then
    echo "Device $HCIF binded."
else
    echo "Binding $HCIF ..."
    rfcomm bind $HCIN $MAC
    sleep 0.2
    if [[ ! -e $HCIF ]]; then
        echo "Device $HCIF not binded"
        exit 1
    fi
fi

exit 0
