/testing/guestbin/swan-prep --nokeys --46
/testing/x509/import.sh real/mainca/east.p12
ipsec start
../../guestbin/wait-until-pluto-started
ipsec auto --add san
echo "initdone"
