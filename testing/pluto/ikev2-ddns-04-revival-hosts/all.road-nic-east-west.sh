# bring up the gateway

nic#

# east is the first responder

east# /testing/guestbin/prep.sh
east# ipsec start
east# ../../guestbin/wait-until-pluto-started
east# ipsec add road-east

# west is the second responder

west# /testing/guestbin/prep.sh
west# ipsec start
west# ../../guestbin/wait-until-pluto-started
west# ipsec add road-west

# road is the initiator

road# /testing/guestbin/prep.sh
road# ipsec start
road# ../../guestbin/wait-until-pluto-started

# on ROAD point RIGHT at EAST

road# ../../guestbin/mount-bind.sh /etc/hosts /etc/hosts
road# echo "192.1.2.23 right.testing.libreswan.org" >> /etc/hosts # EAST

# bring up road-right AKA EAST

road# ipsec add road-right
road# ipsec up road-right

# redirect DNS to WEST

road# cp /etc/hosts /tmp/west.hosts
road# sed -e '/right.testing.libreswan.org/ s/.*/192.1.2.45 right.testing.libreswan.org/' /tmp/west.hosts > /etc/hosts # WEST

# kill existing

east# ipsec stop

# first revival attempt is to east, second is to west (new DNS)

road# ../../guestbin/wait-for-pluto.sh --match '#2: connection is supposed to remain up'
road# ../../guestbin/wait-for-pluto.sh --match '#3: initiating IKEv2 connection'
road# ../../guestbin/wait-for-pluto.sh --match '#3: deleting IKE SA'
road# ../../guestbin/wait-for-pluto.sh --match '#4: initiating IKEv2 connection'
road# ../../guestbin/wait-for-pluto.sh --match '#4: initiator established IKE SA'
road# ../../guestbin/wait-for-pluto.sh --match '#5: initiator established Child SA'

final# ipsec _kernel state
final# ipsec _kernel policy
