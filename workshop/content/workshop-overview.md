This tutorial will act as step-by-step guide in helping you to understand Openshift concepts. It's divided in the following sections:

<ol>
<li>Explore the Web Console</li>
<li>Explore the oc CLI</li>
<li>Deploying a container image</li>
<li>Scaling the application</li>
<li>Source-to-image deployments</li>
<li>Transferring Files in and out of Containers</li>
<li>Using Templates</li>
<li>Connecting to a Database Using Port Forwarding</li>
<li>Using ODO CLI</li>
</ol>

If you are not familiar with the OpenShift Container Platform, it's worth taking a few minutes to understand the basics of the platform as well as the environment that you will be using for this self paced tutorial.  

The goal of OpenShift is to provide a great experience for both Developers and System Administrators to develop, deploy, and run containerized applications.  Developers should love using OpenShift because it enables them to take advantage of both containerized applications and orchestration without having to the know the details.  Developers are free to focus on their code instead of spending time writing Dockerfiles and running docker builds.

OpenShift is a full platform that incorporates several upstream projects while also providing additional features and functionality to make those upstream projects easier to consume.  The core of the platform is containers and orchestration.  For the container side of the house, the platform uses images adhering to the [Open Container Initiative (OCI) image specification](https://github.com/opencontainers/image-spec).  For the orchestration side, we have put a lot of work into the upstream Kubernetes project.  Beyond these two upstream projects, we have created a set of additional Kubernetes objects such as routes and deployment configs that we will learn how to use during this course.  

Both Developers and Operators communicate with the OpenShift Platform via one of the following methods:

### Command Line Interface

The command line tool that we will be using as part of this tutorial is called the *oc* tool. This tool is written in the Go programming language and is a single executable that is provided for Windows, MacOS, and the Linux Operating Systems. 

The developer focused command line tool ODO will be also used in a specific section.

### Web Console

OpenShift also provides a feature rich Web Console that provides a friendly graphical interface for interacting with the platform. The Web Console has both an Administrator Perspective and a Developer Perspective.

### REST API

Both the command line tool and the web console communicate to OpenShift via the same method, the REST API.  Having a robust API allows users to create their own scripts and automation depending on their specific requirements. For detailed information about the REST API, check out the official documentation at: https://docs.openshift.org/latest/rest_api/index.html

During this tutorial, you will be using both the command line tool and the web console.  However, it should be noted that there are plugins for several integrated development environments as well. Learn more about the Red Hat IDE Extensions for OpenShift [here](https://developers.redhat.com/products/openshift-ide-extensions).

Let's get started!