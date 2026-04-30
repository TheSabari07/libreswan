/testing/guestbin/swan-prep --nokeys
/testing/x509/import.sh real/mainca/east.p12
ipsec start
../../guestbin/wait-until-pluto-started
ipsec add north-east-x509-pluto-02
ipsec connectionstatus north-east-x509-pluto-02
echo "initdone"
