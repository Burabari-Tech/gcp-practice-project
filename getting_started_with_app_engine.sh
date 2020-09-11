#! bin/bash

## Task 1: Initialize App Engine

#Initialize your App Engine app with your project and choose its region
gcloud app create --project=$DEVSHELL_PROJECT_ID --region=us-central

#Clone the source code repository for a sample application in the hello_world directory
git clone https://github.com/GoogleCloudPlatform/python-docs-samples

#Navigate to the source directory
cd python-docs-samples/appengine/standard_python3/hello_world


##############################################

## Task 2: Run Hello World application locally

#download and update the packages list
sudo apt-get update

#Set up a Python virtual environment
sudo apt-get install virtualenv -y
virtualenv -p python3 venv
#Activate the virtual environment
source venv/bin/activate
#install dependencies
pip install  -r requirements.txt
#Run the application
#python main.py



##############################################

## Task 3: Deploy and run Hello World on App Engine

#Deploy your Hello World application
gcloud app deploy --appyaml=app.yaml --quiet