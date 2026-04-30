#!/bin/sh

zone=$1

# increment the zone's serial
serial=$(cat zones/serial)
serial=$(expr ${serial} + 1)
echo ${serial} > zones/serial
sed -i -e "/[Ss]erial/ s/[0-9][0-9]*/${serial}/" zones/${zone}

dnssec-signzone -d dsset -g -S -K keys -x -f zones/${zone}.signed -o ${zone} zones/${zone}
