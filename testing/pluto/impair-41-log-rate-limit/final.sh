# Grep east's log for all rate-limited UDP events and the limiter sentinel.
# Columns: plain RC_LOG lines start with 'packet from',
#          debug-stream (over-limit) lines start with '| ',
#          impair lines start with 'impair: '
grep -e '^packet from' \
     -e '^| ' \
     -e '^impair: ' \
     /tmp/pluto.log

# Verify pstats_ike_mangled reflects all drops including suppressed ones.
ipsec globalstatus | grep total.ike.mangled
