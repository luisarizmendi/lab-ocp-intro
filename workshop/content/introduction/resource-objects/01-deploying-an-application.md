Before we get started, be sure that you are in the right project in the CLI:

```execute
oc project lab-intro-{{ username }}
```

You need to deploy a sample application to work with. The application you are going to deploy is the ParksMap web application used in the Intro section.

```execute
oc new-app openshiftroadshow/parksmap-katacoda:1.0.0 --name parksmap
```

By default when using ``oc new-app`` from the command line to deploy an application, the application will not be exposed to the public. As our final step you therefore need to expose the service so that people can access it.

```execute
oc expose svc/parksmap
```

You are now ready to start investigating the resource objects which were created.
