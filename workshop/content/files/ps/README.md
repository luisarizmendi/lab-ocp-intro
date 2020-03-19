## OpenShift Binary Deployment using WAR and Pipeline

Deploy the apache petstore, clone this repo and:

```
oc new-project petstore --display-name="Petstore" --description='Petstore'
oc process -f ps-pipeline.yaml | oc create -f -
oc start-build pipeline
```

#### Pre-requisites:
- Openshift 3.4+
- Setup Jenkins to autocreate when pipeline created, else deploy it
```
oc new-app --template=jenkins-persistent -p JENKINS_IMAGE_STREAM_TAG=jenkins-2-centos7:latest -p NAMESPACE=openshift -p MEMORY_LIMIT=2048Mi -p ENABLE_OAUTH=true
```
- EAP
```
oc import-image registry.access.redhat.com/jboss-eap-7/eap70-openshift --confirm -n openshift
```