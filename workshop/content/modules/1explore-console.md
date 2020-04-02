
{% if username == blank %}
  {% assign username = user %}
{% endif %}

This section focuses on using the web console.

## Exercise: Logging in with the Web Console
To begin, click on the [Console]({{ console_url }}) tab on your screen. This will open the web console on your browser.

You should see a **Red Hat OpenShift Container Platform** , you'll be on a *Projects* page.

## What is a project? Why does it matter?

OpenShift is often referred to as a container application platform in that it is a platform designed for the development and deployment of applications in containers.

To group your application, we use projects. The reason for having a project to contain your application is to allow for controlled access and quotas for developers or teams.

More technically, it's a visualization of the Kubernetes namespace based on the developer access controls.

## Exercise: Creating a Project

Click the blue **Create Project** button.

You should now see a page for creating your first project in the web console. Fill in the _Name_ field as:

```copy
lab-intro-{{ username }}
```

![Create Project](../images/2create-project.png)

The rest of the form is optional and up to you to fill in or ignore. Click *Create* to continue.

After your project is created, you will see some basic information about your project.

<em>
Note: If there is already a project with the name `myproject-{{ username }}` you will get an error, in that case just use any other name for your project. Please, take this into account for the rest of the labs, since it could happen that you find examples with the `myproject-{{ username }}` project name instead of the name that you have chosen
</em>


## Exercise: Explore the Administrator and Developer Perspectives

Notice the navigation menu on the left. When you first log in, you'll typically be in the *Administrator Perspective*. If you are not in the *Administrator Perspective*, click the perspective toggle and switch from **Developer** to **Administrator**.

![Perspective Toggle](../images/2perspective.png)

You're now in the *Administrator Perspective*, where you'll find **Operators**, **Workloads**, **Networking**, **Storage**, **Builds**, and **Administration** menus in the navigation.

Take a quick look around these, clicking on a few of the menus to see more options.

Now, toggle to the *Developer Perspective*. We will spend most of our time in this tutorial in the *Developer Perspective*. The first thing you'll see is the *Topology* view. Right now it is empty, and lists several different ways to add content to your project. Once you have an application deployed, it will be visualized here in *Topology* view.
