
## What's ODO

OpenShift Do (`odo`) is a fast, iterative, and straightforward CLI tool for developers who write, build, and deploy applications on OpenShift.

Existing tools such as `oc` are more operations-focused and require a deep-understanding of Kubernetes and OpenShift concepts. `odo` abstracts away complex Kubernetes and OpenShift concepts for the developer, thus allowing developers to focus on what is most important to them: code.

`odo` is designed to be simple and concise with the following key features:

* Simple syntax and design centered around concepts familiar to developers, such as projects, applications, and components.
* Completely client based. No server is required within the OpenShift cluster for deployment.
* Official support for Node.js and Java components.
* Partial compatibility with languages and frameworks such as Ruby, Perl, PHP, and Python. 
* Detects changes to local code and deploys it to the cluster automatically, giving instant feedback to validate changes in real time.
* Lists all the available components and services from the {product-title} cluster.




## About the example application

The application you will be deploying is a wild west shooter style game.

Applications are often divided into components based on a logical division of labor. For example, an application might consist of a data-storage, backend component that performs the application's primary work and stores the results. The backend component is paired with a user interface, frontend component that accesses the backend to retrieve data and displays it to a user.

The application deployed in this tutorial consists of two such components.

**Backend**

The backend is a Java Spring Boot application. It performs queries against the Kubernetes and OpenShift REST APIs to retrieve a list of the resource objects that were created when you deployed the application. Then, it returns details about these resource objects to the frontend.

**Frontend**

The frontend is the user interface for a wild west style game written in Node.js. It displays popup images which you can shoot, corresponding to the resource objects returned by the backend.


## Creating a new binary component

First, be sure that you are in the `lab-intro-{{ username }}`:

```execute
odo project set lab-intro-{{ username }}
```

As mentioned, applications often consist of two or more components that work together to implement the overall application. OpenShift helps organize these modular applications with a concept called, appropriately enough, the application. An OpenShift application represents all of an app's components in a logical management unit. The `odo` tool helps you manage that group of components and link them together as an application.

A selection of runtimes, frameworks, and other components are available on an OpenShift cluster for building your applications. This list is referred to as the **Developer Catalog**.

List the supported component types in the catalog by running:

```execute
odo catalog list components
```

Administrators can configure the catalog to determine what components are available in the catalog, so the list will vary on different OpenShift clusters. For this scenario, the cluster's catalog list must include `java` and `nodejs`.

Source code for the backend of our `wildwest` application is available in Github:

```execute
cd ~
git clone https://github.com/openshift-evangelists/Wild-West-Backend.git
```

Change directories into the source directory, `Wild-West-Backend`:

```execute
cd ~/Wild-West-Backend
```

Take a look at the contents of the `backend` directory. It's a regular Java Spring Boot application using the Maven build system:

```execute
ls
```

Build the `backend` source files with Maven to create a jar file:

```execute
mvn package
```

Since this is the first time running this build, it may take 30-45 seconds to complete. Subsequent builds will run much more quickly.

With the backend's `.jar` file built, we can use `odo` to deploy and run it atop the Java application server we saw earlier in the catalog. The command below creates a *component* configuration of *component-type* `java` named `backend`:

```execute
odo create java:8 backend --binary target/wildwest-1.0.jar
```

As the component configuration is created, `odo` will print the following:

```
✓  Validating component [6ms]
Please use `odo push` command to create the component with source deployed
```

The component is not yet deployed on OpenShift. With an `odo create` command, a configuration file called `config.yaml` has been created in the local directory of the `backend` component that contains information about the component for deployment.

To see the configuration settings of the `backend` component in `config.yaml`, `odo` has a command to display this information:

```execute
odo config view
```

Since `backend` is a binary component, as specified in the `odo create` command above, changes to the component's source code should be followed by pushing the jar file to a running container. After `mvn` compiled a new `wildwest-1.0.jar` file, the program would be deployed to OpenShift with the `odo push` command. We can execute such a push right now:

```execute
odo push
```

As the push is progressing, `odo` will print output similar to the following:

```
Validation
 ✓  Checking component [13ms]

Configuration changes
 ✓  Initializing component
 ✓  Creating component [107ms]

Pushing to component backend of type binary
 ✓  Checking files for pushing [2ms]
 ✓  Waiting for component to start [59s]
 ✓  Syncing files to the component [14s]
 ✓  Building component [2s]
```

Using `odo push`, OpenShift has created a container to host the `backend` component, deployed the container into a pod running on the OpenShift cluster, and started up the `backend` component.

You can view the `backend` component being started up in the [Web Console]({{ console_url }}) by switching over from the **Administrator** perspective to the **Developer** perspective. To do this, select the **Developer** option from the dropdown menu as shown below:

![Developer Perspective](../images/developer-perspective.png)

After selecting the **Developer** option, you will be on the **Topology** view that shows what components are deployed in your OpenShift project. The `backend` component is successfully deployed as a container that runs on a pod. When a dark blue circle appears around the backend component as shown below, the pod is ready and the `backend` component container will start running on it.

![Backend Pod](../images/backend-pod.png)

If you want to check on the status of an action in `odo`, you can use the `odo log` command. When `odo push` is finished, run `odo log` to follow the progress of the `backend` component deployment:

```execute-2
<ctrl-c>
cd ~/Wild-West-Backend
odo log -f
```

You should see output similar to the following to confirm the `backend` is running on a container in a pod in `myproject`:

```
2019-05-13 12:32:15.986  INFO 729 --- [           main] c.o.wildwest.WildWestApplication         : Started WildWestApplication in 6.337 seconds (JVM running for 7.779)
```

The `backend` jar file has now been pushed, and the `backend` component is running.

## Deploying the Frontend component

With the `backend` component running and connected to persistent storage, we are ready to bring up the `frontend` component and connect it to the `backend`. Once again, source code for the component is already available in GitHub:

```execute
cd ~
git clone https://github.com/openshift-evangelists/Wild-West-Frontend.git
```

Change directories to the `Wild-West-Frontend` directory:

```execute
cd ~/Wild-West-Frontend
```

Listing the contents of this directory shows that `frontend` is a Node.js application.

```execute
ls
```

Since `frontend` is written in an interpreted language, there is no build step analogous to the Maven build we performed for the `backend` component. We can proceed directly to specifying the `nodejs` environment from the cluster's catalog.

We give this Node.js component the name `frontend`:

```execute
odo create nodejs frontend
```

`odo` will create a `config.yaml` just like with the `backend` component, and you should see the following output:

```
✓  Validating component [6ms]
Please use `odo push` command to create the component with source deployed
```

With the component named and the config file created, we can push the Node.js source code from the current directory:

```execute
odo push
```

`odo push` should produce the following output:

```
Validation
 ✓  Checking component [23ms]

Configuration changes
 ✓  Initializing component
 ✓  Creating component [86ms]

Pushing to component frontend of type local
 ✓  Checking files for pushing [710993ns]
 ✓  Waiting for component to start [52s]
 ✓  Syncing files to the component [26s]
 ✓  Building component [8s]
 ✓  Changes successfully pushed to component
```

When we created the `backend` component, we viewed the logs via the terminal. You can also follow the status of your container creation in the [Web Console]({{ console_url }}). Click the **Console** tab and make sure you're in the project named `lab-intro-{{ username }}`.

Depending on how far along your `odo push` is, you may see the pod for the `frontend` component starting up with a light blue ring as shown below. This light blue ring means the pod is in a pending state and hasn't started yet:

![Frontend Pending](../images/frontend-pending.png)

Once the pod becomes available, you'll see the `frontend` component become available with a dark blue ring around it like the `backend` component has. This is shown below:

![Frontend Running](../images/frontend-running.png)

To see the logs of the `frontend` component, wait for the dark blue ring to appear around the component and then click on the `frontend` component circle. This should bring up the deployment config for `frontend` and present the option to **View Logs** under the **Pods** section. This is shown below:

![Frontend Logs](../images/frontend-logs.png)

Click on **View Logs** where you should eventually see the following logs confirming `frontend` is running:

```
CONFIG ERROR: Can't find backend webservices component!
Use `odo link` to link your front-end component to a backend component.
Listening on 0.0.0.0, port 8080
Frontend available at URL_PREFIX: /
{ Error: 'Backend Component Not Configured' }
```

Don't worry about the error message for now! You'll correct this in the next section.

When you are done viewing the logs, click on the **Topology** tab on the left side of the [Web Console]({{ console_url }}) to head back to `lab-intro-{{ username }}`.


## Linking Components

With both components of our application running on the cluster, we need to connect them so they can communicate. OpenShift provides mechanisms to publish communication bindings from a program to its clients. This is referred to as linking.

To link the current `frontend` component to the `backend`, you can run:

```execute
odo link backend --component frontend --port 8080
```

This will inject configuration information into the `frontend` about the `backend` and then restart the `frontend` component.

The following output will be displayed to confirm the linking information has been added to the `frontend` component:

```
✓  Component backend has been successfully linked from the component frontend

The below secret environment variables were added to the 'frontend' component:

· COMPONENT_BACKEND_PORT
· COMPONENT_BACKEND_HOST

You can now access the environment variables from within the component pod, for example:
$COMPONENT_BACKEND_HOST is now available as a variable within component frontend
```

If you head back quickly enough to the [Web Console]({{ console_url }}) by clicking on the **Console** tab, you will see the `frontend` component have its dark blue ring turn light blue again. This means that the pod for `frontend` is being restarted so that it will now run with information about how to connect to the `backend` component. When the frontend component has a dark blue ring around it again, the linking is complete.

Once the linking is complete, you can click on the `frontend` component circle again and select **View Logs**. This time, instead of an error message, you will see the following confirming the `frontend` is properly communicating with the `backend` component:

```
Listening on 0.0.0.0, port 8080
Frontend available at URL_PREFIX: /
Proxying "/ws/*" to 'backend-app:8080'
```

Now that the `frontend` component has been linked with the `backend` component, let's make `frontend` publicly accessible.

## Exposing components

We have updated `frontend` to be linked with `backend` to allow our application's components to communicate. Let's now create an external URL for our application so we can see it in action:

```execute
odo url create frontend --port 8080
```

Once the URL has been created in the `frontend` component's configuration, you will see the following output:

```
✓  URL created for component: frontend

To create URL on the OpenShift cluster, please run `odo push`
```

The change can now be pushed:

```execute
odo push
```

`odo` will print the URL generated for the application. It should be located in the middle of the output from `odo push` similar to the output below:

```
Validation
 ✓  Checking component [34ms]

Configuration changes
 ✓  Retrieving component data [27ms]
 ✓  Applying configuration [25ms]

Applying URL changes
 ✓  URL frontend: http://frontend-app-lab-intro-{{ username }}.{{ cluster_subdomain }} created

Pushing to component frontend of type local
 ✓  Checking file changes for pushing [832029ns]
 ✓  No file changes detected, skipping build. Use the '-f' flag to force the build.
```

Visit the URL in your browser to view the application once the `odo push` command finishes:

http://frontend-app-lab-intro-{{ username }}.{{ cluster_subdomain }}

## Making changes to source code

We've deployed the first version of our application and tested it by visiting it with a browser. Let's look at how OpenShift and `odo` help make it easier to iterate on that app once it's running.

First, make sure you are still in the `frontend` directory:

```execute
cd ~/Wild-West-Frontend
```

Now, we will tell `odo` to `watch` for changes on the file system in the background. Note that the `&` is included to run `odo watch` in the background for this tutorial, but it is usually just run as `odo watch` and can be terminated using `ctrl+c`.

```execute-2
<ctrl-c>
cd ~/Wild-West-Frontend
odo watch 
```

Let's change the displayed name for our wild west game. Currently, the title is "Wild West The OpenShift Way!" We will change this to "My App The OpenShift Way!"

![Application Title](../images/app-name.png)

Edit the file `index.html` with a search-and-replace one-liner performed with the Unix stream editor, `sed`:

```execute
sed -i "s/Wild West/My App/" index.html
```

There may be a slight delay before `odo` recognizes the change. Once the change is recognized, `odo` will push the changes to the `frontend` component and print its status to the terminal:

```
File /root/frontend/index.html changed
File  changed
Pushing files...
✓  Waiting for component to start [10ms]
✓  Syncing files to the component [16s]
✓  Building component [6s]
```

Refresh the application's page in the web browser. You will see the new name in the web interface for the application.

__NOTE__: If you no longer have the application page opened in a browser, you can recall the url by executing:

```execute
odo url list
```



