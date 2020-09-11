#! bin/hash

echo "Task 2: Deploy a web server VM instance"

gcloud compute instances create bloghost \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=us-central1-a \
  --machine-type=e2-medium \
  --subnet=default \
  --network-tier=PREMIUM \
  --metadata=startup-script=apt-get\ update$'\n'apt-get\ install\ apache2\ php\ php-mysql\ -y$'\n'service\ apache2\ restart \
  --maintenance-policy=MIGRATE \
  --scopes=default \
  --tags=http-server \
  --image=debian-9-stretch-v20200902 \
  --image-project=debian-cloud \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=bloghost \
  --reservation-affinity=any

gcloud compute firewall-rules create default-allow-http \
  --project=$DEVSHELL_PROJECT_ID \
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:80 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=http-server



###########################################

echo "Task 3: Create a Cloud Storage bucket using the gsutil command line"

export LOCATION=US
#make bucket named after projectID
#TODO: $DEVSHELL_PROJECT_ID does not have a project by default anymore???
gsutil mb -l $LOCATION gs://$DEVSHELL_PROJECT_ID

#Retrieve a banner image from a publicly accessible Cloud Storage location
gsutil cp gs://cloud-training/gcpfci/my-excellent-blog.png my-excellent-blog.png

#Copy the banner image to your newly created Cloud Storage bucket
gsutil cp my-excellent-blog.png gs://$DEVSHELL_PROJECT_ID/my-excellent-blog.png

#Modify the Access Control List of the object you just created so that it is readable by everyone
gsutil acl ch -u allUsers:R gs://$DEVSHELL_PROJECT_ID/my-excellent-blog.png



###########################################

echo "Task 4: Create the Cloud SQL instance"

gcloud sql instances create blog-db \
  --root-password=mypass \
  --database-version=MYSQL_5_7 \
  --zone=us-central1-a
  
#create new db user account
gcloud sql users create blogdbuser --instance=blog-db --password=mypass
