## Command Line Interface (CLI)

The OpenShift CLI is accessed using the command _oc_. From here, you can administrate the entire OpenShift cluster and deploy new applications.

The CLI exposes the underlying Kubernetes orchestration system with the enhancements made by OpenShift. Users familiar with Kubernetes will be able to adapt to OpenShift quickly. _oc_ provides all of the functionality of _kubectl_, along with additional functionality to make it easier to work with OpenShift. The CLI is ideal in situations where you are:

1) Working directly with project source code

2) Scripting OpenShift operations

3) Restricted by bandwidth resources and cannot use the web console

In this tutorial, we're not focusing on the OpenShift CLI, but we want you to be aware of it in case you prefer using the command line. You can check out our other courses that go into the use of the CLI in more depth. Now, we're just going to practice logging in so you can get some experience with how the CLI works.

## Exercise: Logging in with the CLI
Let's get started by logging in. Your task is to enter the following into the console:

```execute
oc login
```

When prompted, enter the following username and password:

**Username:** `{{ username }}`

**Password:** `<your password>`


You should see output similar to:

```
Authentication required for https://openshift:6443 (openshift)
Username: {{ username }}
Password:
Login successful.

You have one project on this server: "lab-intro-{{ username }}"

Using project "lab-intro-{{ username }}".
```


Next, you can check if it was successful:

```execute
oc whoami
```

`oc whoami` should return a response of:

`{{ username }}`

You can list all the projects you currently have access to by running:

```execute
oc get projects
```


That's it!










