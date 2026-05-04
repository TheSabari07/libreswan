# NIC runs DNS

nic# ../../guestbin/nic-dnssec.sh start

# add a record for right

nic# echo right.testing.libreswan.org. IN A 192.1.2.23 >> /etc/nsd/zones/testing.libreswan.org
nic# tail -1 /etc/nsd/zones/testing.libreswan.org
nic# /testing/dnssec/sign-zone.sh /etc/nsd/zones/testing.libreswan.org
nic# /testing/guestbin/nsd.sh reload
nic# /testing/guestbin/unbound.sh reload

# EAST is the first responder

east# /testing/guestbin/prep.sh
east# ipsec start
east# ../../guestbin/wait-until-pluto-started
east# ipsec add road-east

# WEST is the second responder

west# /testing/guestbin/prep.sh
west# ipsec start
west# ../../guestbin/wait-until-pluto-started
west# ipsec add road-west

# ROAD is the initiator

road# /testing/guestbin/prep.sh
road# dig +short         right.libreswan.org

# bring up road-right (aka EAST)

road# ipsec start
road# ../../guestbin/wait-until-pluto-started
road# ipsec add road-right
road# ipsec up road-right

# On NIC redirect DNS to WEST

nic# sed -i -e '/right.testing.libreswan.org/ s/23/45/' /etc/nsd/zones/testing.libreswan.org # east->west
nic# tail -1 /etc/nsd/zones/testing.libreswan.org
nic# /testing/dnssec/sign-zone.sh /etc/nsd/zones/testing.libreswan.org
nic# /testing/guestbin/nsd.sh reload
nic# /testing/guestbin/unbound.sh reload

road# dig +short         right.libreswan.org

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
