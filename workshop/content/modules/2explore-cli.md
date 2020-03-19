
The OpenShift CLI is accessed using the command _oc_. From here, you can administrate the entire OpenShift cluster and deploy new applications.

The CLI exposes the underlying Kubernetes orchestration system with the enhancements made by OpenShift. Users familiar with Kubernetes will be able to adapt to OpenShift quickly. _oc_ provides all of the functionality of _kubectl_, along with additional functionality to make it easier to work with OpenShift. The CLI is ideal in situations where you are:

1) Working directly with project source code

2) Scripting OpenShift operations

3) Restricted by bandwidth resources and cannot use the web console

In this tutorial, we're not focusing on the OpenShift CLI, but we want you to be aware of it in case you prefer using the command line. You can check out our other courses that go into the use of the CLI in more depth. Now, we're just going to practice logging in so you can get some experience with how the CLI works.

## Logging in with the CLI
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


## About the projects and permissions in CLI

You can list all the projects you currently have access to by running:

```execute
oc get projects
```

We created the project using the Web Console but it could be also created from CLI:

```
oc new-project lab-intro-{{ username }}
```

Also take into account that if you create a project, you are that project’s administrator. This means that you can grant access to other users, too. If you like, give your neighbor `view` access to your project using the following command (full access is with `admin`):

```
oc policy add-role-to-user view <username_to_be_invited>
```

In addition, you can also give access to the OpenShift API to you applications running on the project (some applications would like to check, for example, what routes have been configured) using this command:

```
oc policy add-role-to-user view -z default
```

The oc policy command above is giving a defined role (view) to a user. But we are using a special flag, -z. What does this flag do? From the --help output:

```
-z, --serviceaccount=[]: service account in the current namespace to use as a user
```

The -z syntax is a special one that saves us from having to type out the entire string, which, in this case, is `system:serviceaccount:myproject:default`. It's a nifty shortcut for when you want to apply the command to just the current project.

You can verify that the role has been added correctly by running:

```execute
oc get rolebindings
```

This should now output:

```
NAME                    ROLE                    USERS       GROUPS                             SERVICE ACCOUNTS   SUBJECTS
admin                   /admin                  developer
system:deployers        /system:deployer                                                       deployer
system:image-builders   /system:image-builder                                                  builder
system:image-pullers    /system:image-puller                system:serviceaccounts:myproject
view                    /view                                                                  default
```

Now that the default Service Account has view access, it can query the REST API to see what resources are within the project. This also has the added benefit of suppressing the error message! Although, in reality, we fixed the application.


