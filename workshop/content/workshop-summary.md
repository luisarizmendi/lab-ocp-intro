
{% if username == blank %}
  {% assign username = "user" %}
{% endif %}



**Congratulations! You just learned the basics of using OpenShift Container Platform.**

Here are some of the ways you can get your own OpenShift cluster:

### CodeReady Containers

[CodeReady Containers](https://developers.redhat.com/products/codeready-containers) brings a minimal, preconfigured OpenShift 4.x cluster to your local laptop or desktop computer for development and testing purposes. CodeReady Containers is delivered as a Red Hat Enterprise Linux virtual machine that supports native hypervisors for Linux, macOS, and Windows 10. Follow the [Getting Started Guide](https://code-ready.github.io/crc/) to set up CodeReady Ready Containers.

### OpenShift Online

The OpenShift team provides a hosted, managed environment that frees developers from worrying about infrastructure. OpenShift Online includes a free *Starter* tier for developing and testing applications on OpenShift. OpenShift Online Pro provides scalability for production deployments at competitive monthly rates in a multi-tenant environment. Find details about OpenShift Online, and sign up for free, at https://www.openshift.com/pricing/.

### OpenShift Dedicated

For the highest production requirements, Red Hat hosts and manages dedicated OpenShift instances available only to your organization. OpenShift Dedicated is ideal for larger teams that want the scale and velocity benefits of container cluster orchestration without having to sweat the details of deploying and maintaining secure, reliable infrastructure. To find out more, visit https://www.openshift.com/dedicated/.

### Compare Hosted, Managed, or On Premises OpenShift

Learn more about the different OpenShift platform variants here: https://www.openshift.com/products

### Browse the Documentation

If you want to learn about particular OpenShift concepts in more depth, visit the documentation: https://docs.openshift.com/container-platform/latest


### Clean your environment


If you don't want to use the project created in this workshop, you can delete it and all its contents running the following command:

```execute
oc delete project lab-intro-{{ username }}
```
