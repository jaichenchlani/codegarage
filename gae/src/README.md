## Python Flask Bootstrap App deployed on GCP App Engine ##

### Helper Variables
```
export PROJECT=<GCP Project Name>
export APP_TAG=<app-name>:<version>
export GCR_IMAGE=gcr.io/$PROJECT/$APP_TAG
```

### Setup
1. `docker build -t $APP_TAG .` *Build Image*
2. `docker run -p 8080:8080 $APP_TAG` *Test the application locally*
3. `docker tag $APP_TAG  $GCR_IMAGE` *Tag the gcr image*
4. `docker push $GCR_IMAGE` *Push the GCR Image to GCP Project*
5. `gcloud app deploy` *Deploy the app to GCP App Engine*