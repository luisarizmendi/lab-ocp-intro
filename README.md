LAB - OCP Introduction
=====================

Get started with your Openshift journey


SINGLE and MULTIUSER modes
=====================

This workshop can work in two modes: single user or multiuser. If you run it as multiuser (default) you will need a dynamic persistent volume storage and run this command. If you run the prerequistes as part of this command (with --prerequisites) be aware that there is a nfs-autoprovisioner module (under ./launch/prerequisites) that will be run and that will configure the unsupported NFS dynamic provisioner but, if you decide to run it, YOU WILL NEED TO PREPARE THE FILES WITH THE RIGHT NFS IP ADDRESS AND PATH.

Also take into account that, even if you don't run the prerequisites, you will NEED TO BE LOG IN AS CLUSTER ADMIN in OpenShift since multiple projects and users will be created

Single user workshop is more restricted since it uses a serviceaccount instead of the "real" ocp user.

If you want to run the single add the --singleuser in the command, like this: launch-workshop.sh --singleuser

Deploying the workshop
=====================

Just clone (with submodules) and run:

`git clone --single-branch --branch master --recurse-submodules https://github.com/luisarizmendi/lab-ocp-intro.git`

`cd lab-ocp-intro`

`./launch-workshop.sh`
