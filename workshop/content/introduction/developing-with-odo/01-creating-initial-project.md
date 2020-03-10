## Logging in to OpenShift

Before we get started, you need to log in to OpenShift. To log in to the OpenShift cluster used for this scenario from the _Terminal_,
run:

`odo login -u {{ username }} -p <your password>`

This will log you in using the credentials:

**Username:** `{{ username }}`

**Password:** `<your password>`


You should see the output below:

```
Connecting to the OpenShift cluster

Login successful.

```

You should have the project created in the previous section. If you wouldn't have it, you could create with odo:

```
    odo project create <project-name>
```

## Creating a Service Account
The backend of our application uses the OpenShift REST API. In order for the backend to access the API, we need to grant access to the service account that the backend is using. We will do this in the web console.

Click the [Console]({{ console_url }}) tab next to the [Terminal]({{ terminal_url }}) tab near the center top of your browser. This opens the OpenShift web console.

After logging in to the web console, you'll be in the **Administrator** perspective of the web console, which is a view of the console for handling operations and administrative tasks associated with your OpenShift cluster.

To start, select the project you just created using `odo` (i.e. `lab-intro-{{ username }}`) by clicking on `lab-intro-{{ username }}` on the **Projects** page as shown below:

![Projects](../../assets/introduction/developing-with-odo-42/myproject.png)

By clicking on the project name, you will be taken to the **Project Details** page that shows information about what is happening in your project. By clicking on the project name, you are also now using this project and all actions via the web console will now happen in this project.

On the left side of the console, click the **Administration** tab and select the **RoleBindings** option as shown below:

![Role Binding](../../assets/introduction/developing-with-odo-42/role-binding.png)

On the **RoleBindings** page, click the **Create Binding** button and fill out the wizard with your user and project information:

![Role Binding Wizard](../../assets/introduction/developing-with-odo-42/role-binding-wizard.png)

Feel free to copy the information for the role binding name and service account subject name below:

**Role Binding Name:** ``defaultview``

**Subject Name:** ``default``

Now the service account that the backend uses has **view** access so it can retrieve objects via the API. Note that you could choose **edit** access instead. That would allow the backend to both retrieve and modify or delete objects. If you do that, you can end up destroying certain resources in the game that are not recoverable, which is why we are choosing **view** access for this scenario.
