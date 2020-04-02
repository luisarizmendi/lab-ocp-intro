#!/bin/bash

WORKSHOP_NAME="ocp-intro"

USERCOUNT=30

RUN_PREREQUISITES=false
MULTIUSER=true
CLEANUP=false

IS_CLUSTER_ADMIN=no
IS_OC_USER=no


IS_CLUSTER_ADMIN=$(oc auth can-i create pods --all-namespaces)

while [[ $# -gt 0 ]] && [[ ."$1" = .--* ]] ;
do
    opt="$1";
    shift;              #expose next argument
    case "$opt" in
        "--" ) break 2;;
        "--cleanup" )
           CLEANUP="true";;
        "--prerequisites" )
           RUN_PREREQUISITES="true";;
        "--singleuser" )
           MULTIUSER="false";;
        *) exit 0;;
   esac
done



if [ $CLEANUP = true ]
then
  echo "*********************"
  echo "* REMOVING PROJECTS *"
  echo "*********************"

  mypath=$(find  ~ -name lab-${WORKSHOP_NAME})

  if [ $(cat $mypath/typedeployed) = multiuser ]
  then

        oc delete project lab-${WORKSHOP_NAME} > /dev/null 2>&1

#        for i in $(eval echo "{1..$USERCOUNT}") ; do
#          echo "Deleting project workshop-${WORKSHOP_NAME}-user$i..."
#          oc delete project lab-${WORKSHOP_NAME}-user$i > /dev/null 2>&1
#        done

  else
    oc delete project lab-${WORKSHOP_NAME}-$(oc whoami) > /dev/null 2>&1

  fi

  exit 0

fi


if [ $RUN_PREREQUISITES = true ]
then


    if [ $IS_CLUSTER_ADMIN = no ]; then
        echo ""; echo "YOU NEED TO LOG AS CLUSTER ADMIN!"; echo ""; exit -1
    fi


    echo "Running pre-requisites"
    echo "**********************"
    echo ""

    echo "Configure authentication"
    cd prerequisites/authentication/  ; chmod +x run.sh ; ./run.sh ; cd ../..
    sleep 15
    oc login -u clusteradmin -p redhat  > /dev/null 2>&1


    if [ $MULTIUSER = true ]
    then

      echo "Configure NFS autoprovisioner (not supported, only for PoC)"
      cd prerequisites/nfs-autoprovisioner/  ; chmod +x run.sh ; ./run.sh ; cd ../..

#      echo "Create projects to run the workshop"

#      for i in $(eval echo "{1..$USERCOUNT}") ; do
#      oc login -u user$i -p redhat  > /dev/null 2>&1
#      oc login -u clusteradmin -p redhat > /dev/null 2>&1
#      oc new-project ${WORKSHOP_NAME}-user$i > /dev/null 2>&1
#      oc adm policy add-role-to-user admin user$i -n workshop-${WORKSHOP_NAME}-user$i
#      done

    fi

else

  if [ $MULTIUSER = true ]; then
  echo "*********************************************************************************"
  echo "*                                   NOTE                                        *"
  echo "*********************************************************************************"
  echo ""
  echo "This Workshop require at least one user with admin role."
  echo "If multiuser mode is selected (default) a dynamic PV will be used by the spawner"
  echo "of the workshop environments. You can deploy automatically the pre-requirements "
  echo "using --prerequisites, it creates local user accounts and deploy the (unsupported)"
  echo "dynamic NFS autoprovisioner (that must be configured pointing to the NFS server IP"
  echo "before running the script)"
  echo ""
  echo "If no dynamic PV is possible in this environment, use the --singleuser option but"
  echo "be aware that in that case you will be using a Service Account instead of the users"
  echo "account, and that could affect some of the steps described in the Workshop"
  echo ""
  echo "*********************************************************************************"
  echo ""
  echo ""
  read -p "                        PRESS ENTER TO CONTINUE"
  fi


fi

if [ $MULTIUSER = true ]; then
  if [ $IS_CLUSTER_ADMIN = no ]; then
      echo ""; echo "YOU NEED TO LOG AS CLUSTER ADMIN!"; echo ""; exit -1
  fi
fi


echo "Building and deploying workshop"

if [ $MULTIUSER = true ]
then
  oc new-project lab-${WORKSHOP_NAME} > /dev/null 2>&1
  oc project lab-${WORKSHOP_NAME}  > /dev/null 2>&1
  #.workshop/scripts/deploy-spawner.sh  --settings=develop
  .workshop/scripts/deploy-spawner.sh
  #echo "multiuser" > typedeployed
else
#  oc new-project lab-${WORKSHOP_NAME}-$(oc whoami) > /dev/null 2>&1
#  oc project lab-${WORKSHOP_NAME}-$(oc whoami)  > /dev/null 2>&1
  #.workshop/scripts/deploy-personal.sh  --settings=develop
  .workshop/scripts/deploy-personal.sh
  #echo "personal" > typedeployed
fi


###
# NOTE: I'm using an image with the workshop already built. quay.io/luisarizmendi/lab-ocp-intro:1.x
# If you want to make any changes # you need to run .workshop/scripts/build-workshop.sh
# after making the changes.
# You can also start from the "base" image instead from the one hosted in my quay account, you need to
# change the WORKSHOP_IMAGE variable in the .workshop/settings.sh script to use, for example,
# quay.io/openshifthomeroom/lab-markdown-sample:1.10
###
#sleep 30
#.workshop/scripts/build-workshop.sh
#sleep 30
#oc rollout status $(oc get dc -o name | grep -i ${WORKSHOP_NAME})
#sleep 10



if [ $MULTIUSER = true ]
then
  WORKSHOP_URL=$(oc get routes.route.openshift.io -n lab-${WORKSHOP_NAME} | grep ${WORKSHOP_NAME} | awk '{print $2}')
else
  WORKSHOP_URL=$(oc get routes.route.openshift.io | grep ${WORKSHOP_NAME} | awk '{print $2}')
fi


echo ""
echo ""
echo "**********************************************************************************************"
echo "   Now you can open https://$WORKSHOP_URL"
echo ""
echo "   Use your OpenShift credentials to log in"
echo "**********************************************************************************************"
echo ""
