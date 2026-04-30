/testing/guestbin/swan-prep --nokeys --46
/testing/x509/import.sh real/mainca/west.p12
ipsec start
../../guestbin/wait-until-pluto-started
ipsec add san
ipsec listpubkeys
ipsec certutil -L west -n west | grep 'IP Address:'
echo "initdone"
