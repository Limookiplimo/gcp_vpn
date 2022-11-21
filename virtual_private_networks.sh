#!/bin/bash

#limookiplimo@gmail.com

gcloud compute networks list

gcloud compute firewall-rules list

gcloud compute ssh server-1 --command="ping -c 3 <server-2_external_IP_address>" && \
    gcloud compute ssh server-1 --command="ping -c 3 <server-2_internal_IP_address>"

gcloud compute ssh server-2 --command="ping -c 3 <server-2_external_IP_address>" && \
	gcloud compute ssh server-2 --command="ping -c 3 <server-2_internal_IP_address>"

gcloud compute addresses create vpn-1-static-ip --ip-version=IPv4 --region=us-central1 && \
    gcloud compute addresses create vpn-2-static-ip --ip-version=IPv4 --region=europe-west1

gcloud compute target-vpn-gateways create vpn-1 --region=us-central1 --network=vpn-network-1 --address=vpn-1-static-ip

gcloud compute vpn-tunnels create tunnel1to2 --shared-secret=gcprocks --peer-address= [VPN-2-STATIC-IP] && \
	--local-traffic-selector=0.0.0.0/0 --destination-range=10.1.3.0/24 --target-vpn-gateway=vpn-1

gcloud compute target-vpn-gateways create vpn-2 --region=europe-west1 --network=vpn-network-2 --address=vpn-1-static-ip

gcloud compute vpn-tunnels create tunnel2to1 --shared-secret=gcprocks --peer-address= [VPN-1-STATIC-IP] && \
	--local-traffic-selector=0.0.0.0/0 --destination-range=10.5.4.0/24 --target-vpn-gateway=vpn-2

gcloud compute ssh server-1 --command="ping -c 3 <server-2_internal_IP_address>" && \
	gcloud compute ssh server-2 --command="ping -c 3 <server-1_internal_IP_address>"