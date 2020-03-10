Before we get started, be sure that you are in the right project

```execute
oc project lab-intro-{{ username }}
```


Switch to the _Console_ and login to the OpenShift web console using the
same credentials you used above.

![Web Console Login](../../assets/introduction/deploying-images-42/01-web-console-login.png)

This should leave you at the list of projects you have access to. As we only
created the one project, all you should see is ``myproject``.

![List of Projects](../../assets/introduction/deploying-images-42/01-list-of-projects.png)

Click on ``myproject`` and you should then be at the _Overview_ page for
the project. Select the _Developer_ perspective for the project instead of the _Adminstrator_ perspective in the left hand side menu. If necessary click on the hamburger menu icon top left of the web console to expose the left hand side menu.

As the project is currently empty, no workloads should be found and you will be presented with various options for how you can deploy an application.

![Add to Project](../../assets/introduction/deploying-images-42/01-add-to-project.png)
