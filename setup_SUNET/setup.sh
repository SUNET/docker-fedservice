#!/bin/bash
cd /opt/openidfed/

#Trust Anchor
docker exec -t openidfed-ta_eu-1 bash -c "/src/fedservice/setup_federation/get_info.py  -k -t https://0.0.0.0:8443 > /data/trust_anchor.json"
sed -i 's@https://0.0.0.0:8443@https://openidfed-test-1.sunet.se:7001@' trust_anchor-eu/trust_anchor.json

# TMI
# prepare
# 1 & 2
cp trust_anchor-eu/trust_anchor.json trust_mark_issuer/trust_anchor-eu.json
docker exec -t openidfed-tmi-1 bash -c "/src/fedservice/setup_federation/add_info.py -s /data/trust_anchor-eu.json -t /data/trust_anchors/"
docker exec -t openidfed-tmi-1 bash -c "echo -e 'https://openidfed-test-1.sunet.se:7001' >> /data/authority_hints"
rm trust_mark_issuer/trust_anchor-eu.json

#3
docker exec -t openidfed-tmi-1 bash -c "/src/fedservice/setup_federation/get_info.py -k -s https://0.0.0.0:8443 > /data/tmi.json"
sed -i 's@https://0.0.0.0:8443@https://openidfed-test-1.sunet.se:6001@' trust_mark_issuer/tmi.json

cp trust_mark_issuer/tmi.json trust_anchor-eu/tmi.json
docker exec -t openidfed-ta_eu-1 bash -c "/src/fedservice/setup_federation/add_info.py -s /data/tmi.json -t /data/subordinates"
rm trust_mark_issuer/tmi.json trust_anchor-eu/tmi.json

#4
docker exec -t openidfed-tmi-1 bash -c "/src/fedservice/setup_federation/issuer.py /data > /data/tmi-issuer.json"
cp trust_mark_issuer/tmi-issuer.json trust_anchor-eu
docker exec -t openidfed-ta_eu-1 bash -c "/src/fedservice/setup_federation/add_info.py -s /data/tmi-issuer.json -t /data/trust_mark_issuers"
rm trust_mark_issuer/tmi-issuer.json trust_anchor-eu/tmi-issuer.json

# Wallet Provider
## Adding information about trust anchors
## Add authority hints
cp trust_anchor-eu/trust_anchor.json wallet_provider/trust_anchor-eu.json
docker exec -t openidfed-wallet_provider-1 bash -c "/src/fedservice/setup_federation/add_info.py -s /data/trust_anchor-eu.json -t /data/trust_anchors"
docker exec -t openidfed-wallet_provider-1 bash -c "echo -e 'https://openidfed-test-1.sunet.se:7001' >> /data/authority_hints"
rm wallet_provider/trust_anchor-eu.json

#Add information about the wallet provider as a subordinate to the trust anchor
docker exec -t openidfed-wallet_provider-1 bash -c "/src/fedservice/setup_federation/get_info.py -k -s https://0.0.0.0:8443 > /data/wallet.json"
sed -i 's@https://0.0.0.0:8443@https://openidfed-test-1.sunet.se:5001@' wallet_provider/wallet.json
cp wallet_provider/wallet.json trust_anchor-eu/wallet.json
docker exec -t openidfed-ta_eu-1 bash -c "/src/fedservice/setup_federation/add_info.py -s /data/wallet.json -t /data/subordinates"
rm wallet_provider/wallet.json trust_anchor-eu/wallet.json

rm trust_anchor-eu/trust_anchor.json
