#! bin/bash

# Enable the Compute service
gcloud services enable compute.googleapis.com

## Task 1: Create a utility virtual machine 

gcloud compute instances create instance-1 \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=us-central1-c \
  --machine-type=n1-standard-1 \
  --subnet=default \
  --no-address \
  --maintenance-policy=MIGRATE \
  --image-project=debian-cloud \
  --image=debian-9-stretch-v20200902 \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=instance-1




###########################################################

## Task 2: Create a Windows virtual machine	

gcloud compute instances create windows-vm \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=europe-west2-a \
  --machine-type=n1-standard-2 \
  --subnet=default \
  --network-tier=PREMIUM \
  --maintenance-policy=MIGRATE \
  --scopes=default \
  --tags=http-server,https-server \
  --image-project=windows-cloud \
  --image=windows-server-2016-dc-core-v20200813 \
  --boot-disk-size=100GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=windows-vm \
  --no-shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring


gcloud compute firewall-rules create default-allow-http \
  --project=$DEVSHELL_PROJECT_ID \
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:80 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=http-server

gcloud compute firewall-rules create default-allow-https \
  --project=$DEVSHELL_PROJECT_ID \
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:443 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=https-server



###########################################################

## Task 3: Create a custom virtual machine

gcloud compute instances create custom-vm \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=us-west1-b \
  --machine-type=custom-6-32768 \
  --subnet=default \
  --network-tier=PREMIUM \
  --maintenance-policy=MIGRATE \
  --scopes=default \
  --image-project=debian-cloud \
  --image=debian-9-stretch-v20200902 \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=custom-vm


## Set/Reset New User Password
gcloud compute reset-windows-password windows-vm --zone=europe-west2-a --user=Burabari --quiet
