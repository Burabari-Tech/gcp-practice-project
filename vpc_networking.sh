#! bin/bash

##Task 2. Create an auto mode network

# Create an auto mode VPC network with firewall rules

gcloud compute networks create mynetwork \
  --project=$DEVSHELL_PROJECT_ID \
  --subnet-mode=auto \
  --bgp-routing-mode=regional

gcloud compute firewall-rules create mynetwork-allow-icmp \
  --project=$DEVSHELL_PROJECT_ID \
  --network=projects/$DEVSHELL_PROJECT_ID/global/networks/mynetwork \
  --direction=INGRESS \
  --priority=65534 \
  --source-ranges=0.0.0.0/0 \
  --action=ALLOW \
  --rules=icmp

gcloud compute firewall-rules create mynetwork-allow-internal \
  --project=$DEVSHELL_PROJECT_ID \
  --network=projects/$DEVSHELL_PROJECT_ID/global/networks/mynetwork \
  --direction=INGRESS \
  --priority=65534 \
  --source-ranges=10.128.0.0/9 \
  --action=ALLOW \
  --rules=all

gcloud compute firewall-rules create mynetwork-allow-rdp \
  --project=$DEVSHELL_PROJECT_ID \
  --network=projects/$DEVSHELL_PROJECT_ID/global/networks/mynetwork \
  --direction=INGRESS \
  --priority=65534 \
  --source-ranges=0.0.0.0/0 \
  --action=ALLOW \
  --rules=tcp:3389

gcloud compute firewall-rules create mynetwork-allow-ssh \
  --project=$DEVSHELL_PROJECT_ID \
  --network=projects/$DEVSHELL_PROJECT_ID/global/networks/mynetwork \
  --direction=INGRESS \
  --priority=65534 \
  --source-ranges=0.0.0.0/0 \
  --action=ALLOW \
  --rules=tcp:22


# Create a VM instance in us-central1

gcloud compute instances create mynet-us-vm \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=us-central1-c \
  --machine-type=n1-standard-1 \
  --subnet=mynetwork \
  --network-tier=PREMIUM \
  --maintenance-policy=MIGRATE \
  --scopes=default \
  --image=debian-9-stretch-v20200902 \
  --image-project=debian-cloud \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=mynet-us-vm \
  --reservation-affinity=any


# Create a VM instance in europe-west1

gcloud compute instances create mynet-eu-vm \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=europe-west1-c \
  --machine-type=n1-standard-1 \
  --subnet=mynetwork \
  --network-tier=PREMIUM \
  --maintenance-policy=MIGRATE \
  --scopes=default \
  --image=debian-9-stretch-v20200902 \
  --image-project=debian-cloud \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=mynet-eu-vm \
  --reservation-affinity=any


# Verify connectivity for the VM instances

# Ping mynet-eu-vm from mynet-us-vm
#ping -c 3 10.132.0.2
#ping -c 3 mynet-eu-vm

# Convert the network to a custom mode network

#TODO: CLI For converting Auto-Mode network to Custom-Mode network
gcloud compute networks update mynetwork --switch-to-custom-subnet-mode --quiet



###############################################

## Task 3. Create custom mode networks

# Create the managementnet network

gcloud compute networks create managementnet \
  --project=$DEVSHELL_PROJECT_ID \
  --subnet-mode=custom \
  --bgp-routing-mode=regional

gcloud compute networks subnets create managementsubnet-us \
  --project=$DEVSHELL_PROJECT_ID \
  --range=10.130.0.0/20 \
  --network=managementnet \
  --region=us-central1

# Create the privatenet network

gcloud compute networks create privatenet --subnet-mode=custom

gcloud compute networks subnets create privatesubnet-us \
  --network=privatenet \
  --region=us-central1 \
  --range=172.16.0.0/24

gcloud compute networks subnets create privatesubnet-eu \
  --network=privatenet \
  --region=europe-west1 \
  --range=172.20.0.0/20

# Create the firewall rules for managementnet

gcloud compute firewall-rules create managementnet-allow-icmp-ssh-rdp \
  --project=$DEVSHELL_PROJECT_ID \
  --direction=INGRESS \
  --priority=1000 \
  --network=managementnet \
  --action=ALLOW \
  --rules=tcp:22,tcp:3389,icmp \
  --source-ranges=0.0.0.0/0

# Create the firewall rules for privatenet

gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp \
  --direction=INGRESS \
  --priority=1000 \
  --network=privatenet \
  --action=ALLOW \
  --rules=icmp,tcp:22,tcp:3389 \
  --source-ranges=0.0.0.0/0

# Create the managementnet-us-vm instance

gcloud compute instances create managementnet-us-vm \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=us-central1-c \
  --machine-type=f1-micro \
  --subnet=managementsubnet-us \
  --network-tier=PREMIUM \
  --maintenance-policy=MIGRATE \
  --scopes=default \
  --image=debian-9-stretch-v20200902 \
  --image-project=debian-cloud \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=managementnet-us-vm \
  --reservation-affinity=any

# Create the privatenet-us-vm instance

gcloud compute instances create privatenet-us-vm \
  --zone=us-central1-c \
  --machine-type=f1-micro \
  --subnet=privatesubnet-us
