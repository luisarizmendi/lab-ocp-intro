 #/bin/bash

echo "****************************"
echo "Configuring Authentication"
echo "****************************"

## Create htpasswd file with users
#sudo yum install -y httpd-tools
#htpasswd -c -B -b users.htpasswd clusteradmin redhat
#htpasswd -b users.htpasswd viewuser redhat
#htpasswd -b users.htpasswd user1 redhat
#htpasswd -b users.htpasswd user2 redhat
#htpasswd -b users.htpasswd user3 redhat
#htpasswd -b users.htpasswd user4 redhat
#htpasswd -b users.htpasswd user5 redhat
#htpasswd -b users.htpasswd user6 redhat
#htpasswd -b users.htpasswd user7 redhat
#htpasswd -b users.htpasswd user8 redhat
#htpasswd -b users.htpasswd user9 redhat
#htpasswd -b users.htpasswd user10 redhat
#htpasswd -b users.htpasswd user11 redhat
#htpasswd -b users.htpasswd user12 redhat
#htpasswd -b users.htpasswd user13 redhat
#htpasswd -b users.htpasswd user14 redhat
#htpasswd -b users.htpasswd user15 redhat
#htpasswd -b users.htpasswd user16 redhat
#htpasswd -b users.htpasswd user17 redhat
#htpasswd -b users.htpasswd user18 redhat
#htpasswd -b users.htpasswd user19 redhat
#htpasswd -b users.htpasswd user20 redhat
#htpasswd -b users.htpasswd user21 redhat
#htpasswd -b users.htpasswd user22 redhat
#htpasswd -b users.htpasswd user23 redhat
#htpasswd -b users.htpasswd user24 redhat
#htpasswd -b users.htpasswd user25 redhat


# Assign htpasswd file to auth provisioner and enable provisioner
oc create secret generic htpass-secret --from-file=htpasswd=users.htpasswd -n openshift-config
oc apply -f descriptors.yaml


# Create cluster admin
oc adm policy add-cluster-role-to-user cluster-admin clusteradmin


# Create groups
oc adm groups new developers user1 user2 user3 user4 user5 user6 user7 user8 user9 user10 user11 user12 user13 user14 user15 user99
oc adm groups new reviewers viewuser


# Assign roles to groups
oc adm policy add-cluster-role-to-group view reviewers
oc adm policy add-role-to-group admin developers


# Remove kubeadmin
oc delete secrets kubeadmin -n kube-system
