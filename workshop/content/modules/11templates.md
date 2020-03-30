

In these exercises, we're going to deploy a complete backend application, consisting of
a REST API backend and a Mongo database. The complete application will already
be wired together and described as a backend for the ParksMap front end application, so
that once the application is built and deployed, you will be able to see the new
map data straight away.

![Application Architecture](../images/10-application-architecture-stage-5.png)

## Background: Templates

Running all the individual commands to deploy an application can be tedious and error prone if you need to do it multiple times.

Fortunately for you, all of this configuration can be captured into a single
*Template* which can then be processed to create a full set of resources. As you
saw with the Mongo database, a *Template* may define parameters for certain values, such as
database username or password, with them optionally being able to be automatically generated by OpenShift when the _Template_ is processed.

Administrators can load *Templates* into OpenShift and make them available to
all users, even via the web console. Users can create *Templates* and load them
into their own *Projects* for other users (with access) to share and use.

The great thing about *Templates* is that they can speed up the deployment
workflow for application development by providing a "recipe" of sorts that can
be deployed with a single command.  Not only that, they can be loaded into
OpenShift from an external URL, which will allow you to keep your templates in a
version control system.

Let's combine all of the exercises you have performed in the last several exercises by
using a *Template* that you can instantiate with a single command.  While you
could have used templates to deploy everything in the workshop, it was done as separate steps so you could understand how to create, deploy, and wire
resources together yourself.

## Making Some Extra Room

You have already deployed several appls, let's delete them, run:

```execute
oc delete all --all
```

## The 'oc create' command

During the Template creating We'll be using the `oc create` command.

The ``oc edit`` command reviewed in the previous section (scaling) would be used to change an existing resource object, it cannot be used to create a new object. To create a new object you need to use the ``oc create`` command.

The ``oc create`` command provides a generic way of creating any resource object from a JSON or YAML definition, as well as a simpler option driven method for a subset of resource object types.

If for example you wanted to create a secure route for an application with your own host name, you would create a ``fqdn.json`` file containing the definition of the route:

```
{
    "kind": "Route",
    "apiVersion": "v1",
    "metadata": {
        "name": "fqdn",
        "labels": {
            "app": "parksmap"
        }
    },
    "spec": {
        "host": "www.example.com",
        "to": {
            "kind": "Service",
            "name": "parksmap",
            "weight": 100
        },
        "port": {
            "targetPort": "8080-tcp"
        },
        "tls": {
            "termination": "edge",
            "insecureEdgeTerminationPolicy": "Allow"
        }
    }
}
```

To create the route from the ``fqdn.json`` file you would run the command:

`oc create -f fqdn.json`

In this example we created a route with ``oc create`` but in fact this command provides a sub command specifically for creating a route (this does not happen for all objects though). You could therefore also have run ``oc create route`` using the command:

``oc create route edge parksmap-fqdn --service parksmap --insecure-policy Allow --hostname www.example.com``

To see the list of resource object types that ``oc create`` has more specific support for, run:

```execute
oc create --help
```

The ``oc create`` command allows you to create a new resource object from a JSON or YAML definition contained in a file. To change an existing resource object using ``oc edit`` was an interactive process. To be able to change an existing resource from a JSON or YAML definition contained in a file, you can use the ``oc replace`` command.

For example, to disallow an insecure route you create a modified definition of the route object:

```
{
    "kind": "Route",
    "apiVersion": "v1",
    "metadata": {
        "name": "fqdn",
        "labels": {
            "app": "parksmap"
        }
    },
    "spec": {
        "host": "www.example.com",
        "to": {
            "kind": "Service",
            "name": "parksmap",
            "weight": 100
        },
        "port": {
            "targetPort": "8080-tcp"
        },
        "tls": {
            "termination": "edge",
            "insecureEdgeTerminationPolicy": "Redirect"
        }
    }
}
```

and then run:

```execute
oc replace -f fqdn.json
```

In order for ``oc replace`` to target the correct resource object, the ``metadata.name`` value of the JSON or YAML definition must be the same as that to be changed.

To script the updating of a value in an existing resource object using ``oc replace``, it is necessary to fetch the definition of the existing resource object using ``oc get``. The definition can then be edited and ``oc replace`` used to update the existing resource object.

To edit the definition will require a way of editing the JSON or YAML definition on the fly. The alternative to this process is to use the ``oc patch`` command, which will edit a value in place for you based on a supplied specification.

The ``route.spec.tls.insecureEdgeTerminationPolicy`` value could for example be switched back to allowing an insecure route by running:

```execute
oc patch route/fqdn --patch '{"spec":{"tls": {"insecureEdgeTerminationPolicy": "Allow"}}}'
```

For both cases, the resource object to be updated must already exist or the command will fail. If you do not know whether the resource object will already exist, and want it updated if it does, but created if it does not, instead of using ``oc replace``, you can use ``oc apply``.





## Instantiate a Template

The front end application we've been working with this whole time will display
as many back end services' data as are created. Adding more stuff with the right
*Label* will make more stuff show up on the map.

Now you will deploy a service to provide data for Major League Baseball stadiums in the US by using a
template. It is pre-configured to build the back end application, and
deploy the Mongo database. It also uses a *Hook* to call the `/ws/data/load`
endpoint to cause the data to be loaded into the database from a JSON file in
the source code repository.

To load the _Template_ execute the following command:

```execute
oc create -f https://raw.githubusercontent.com/openshift-evangelists/wordpress-quickstart/master/templates/classic-standalone.json
```

What just happened? What did you just create? The item that we passed to the `oc create`
command is a *Template*. The `oc create` simply makes the template available in
your *Project*.

You can see what _Templates_ you have available in your project by running:

```execute
oc get templates
```

You will see output like the following:

```
NAME                           DESCRIPTION                                                                        PARAMETERS         OBJECTS
wordpress-classic-standalone   Creates a WordPress installation with separate MySQL database instance. Requi...   12 (2 generated)   9
```

You can list parameters with the CLI by using the following command and specifying the file to be used:

```execute
oc process --parameters -f https://raw.githubusercontent.com/openshift-evangelists/wordpress-quickstart/master/templates/classic-standalone.json
```
Alternatively, if the template is already uploaded:

```execute
oc process --parameters wordpress-classic-standalone
```

For example:

```
NAME                            DESCRIPTION                                       GENERATOR           VALUE
APPLICATION_NAME                The name of the WordPress instance.                                   my-wordpress-site
QUICKSTART_REPOSITORY_URL       The URL of the quickstart Git repository.                             https://github.com/openshift-evangelists/wordpress-quickstart
WORDPRESS_VOLUME_SIZE           Size of the persistent volume for Wordpress.                          1Gi
WORDPRESS_VOLUME_TYPE           Type of the persistent volume for Wordpress.                          ReadWriteOnce
WORDPRESS_DEPLOYMENT_STRATEGY   Type of the deployment strategy for Wordpress.                        Recreate
WORDPRESS_MEMORY_LIMIT          Amount of memory available to WordPress.                              512Mi
DATABASE_VOLUME_SIZE            Size of the persistent volume for the database.                       1Gi
DATABASE_MEMORY_LIMIT           Amount of memory available to the database.                           512Mi
DATABASE_USERNAME               The name of the database user.                    expression          user[a-f0-9]{8}
DATABASE_PASSWORD               The password for the database user.               expression          [a-zA-Z0-9]{12}
MYSQL_VERSION                   The version of the MySQL database.                                    5.7
PHP_VERSION                     The version of the PHP builder.                                       7.0
```


The output identifies several parameters that are generated with a regular expression-like generator when the template is processed.


Are you ready for the magic command? you can run it in two ways: 

The first way is processing to get the actual yaml files and use them with the `oc create` command. Something like:

```
oc process -f <filename> | oc create -f -
```

or if the template is already uploaded:

```
oc process <template name> | oc create -f -
```

You can override any parameter values defined in the file by adding the -p option for each `<name>=<value>` pair you want to override. A parameter reference may appear in any text field inside the template items.

```
oc process <template name> -p <name>=<value> -p <name>=<value> | oc create -f -
```

You can also create an environment file with all parameters with one parameter per line in the `<name>=<value>` format, and the use and use it like this:

```
oc process <template name> --param-file=<env. file> | oc create -f -
```


The second option is just use `oc new-app`, let's use this one:

```execute
oc new-app wordpress-classic-standalone -p DATABASE_PASSWORD=redhat -p MYSQL_USER=wpuser
```

You will see output similar to:

```
--> Deploying template "testing/wordpress-classic-standalone" to project testing

     WordPress (Classic / Standalone)
     ---------
     Creates a WordPress installation with separate MySQL database instance. Requires that two persistent volumes be available. If a ReadWriteMany persistent volume type is
 available and used, WordPress can be scaled to multiple replicas and the deployment strategy switched to Rolling to permit rolling deployments on restarts.

     * With parameters:
        * APPLICATION_NAME=my-wordpress-site
        * QUICKSTART_REPOSITORY_URL=https://github.com/openshift-evangelists/wordpress-quickstart
        * WORDPRESS_VOLUME_SIZE=1Gi
        * WORDPRESS_VOLUME_TYPE=ReadWriteOnce
        * WORDPRESS_DEPLOYMENT_STRATEGY=Recreate
        * WORDPRESS_MEMORY_LIMIT=512Mi
        * DATABASE_VOLUME_SIZE=1Gi
        * DATABASE_MEMORY_LIMIT=512Mi
        * DATABASE_USERNAME=user6c5d3adc # generated
        * DATABASE_PASSWORD=gIBJrNINSsyn # generated
        * MYSQL_VERSION=5.7
        * PHP_VERSION=7.0

--> Creating resources ...
    imagestream.image.openshift.io "my-wordpress-site-img" created
    buildconfig.build.openshift.io "my-wordpress-site" created
    deploymentconfig.apps.openshift.io "my-wordpress-site" created
    deploymentconfig.apps.openshift.io "my-wordpress-site-db" created
    service "my-wordpress-site" created
    service "my-wordpress-site-db" created
    route.route.openshift.io "my-wordpress-site" created
    persistentvolumeclaim "my-wordpress-site-mysql-data" created
    persistentvolumeclaim "my-wordpress-site-wordpress-data" created
--> Success
    Build scheduled, use 'oc logs -f bc/my-wordpress-site' to track its progress.
    Access your application via route 'my-wordpress-site-testing.apps.ocp.136.243.40.222.nip.io'
    Run 'oc status' to view your app.
```

OpenShift will now:

* Configure and start a build
  * From the supplied source code repository
* Configure and deploy the database
  * Using auto-generated user, password, and database name
* Configure environment variables for the app to connect to the database
* Create the correct services
* Label the app service

All with one command!

To monitor the proress of the deployment from the command line run:

```execute
oc logs -f bc/my-wordpress-site
```

or

```execute-2
oc rollout status dc/my-wordpress-site
```

While you wait, you can dig around in the web console to see what was created.

When the build is complete and the deployment finished, visit the URL for the ParksMap front end application.

http://my-wordpress-site-lab-intro-{{ username }}.{{ cluster_subdomain }}

Does it work?

Think about how
this could be used in your environment.  For example, a template could define a
large set of resources that make up a "reference application", complete with
several app servers, databases, and more.  You could deploy the entire set of
resources with one command, and then hack on them to develop new features,
microservices, fix bugs, and more.

As a final exercise, look at the template that was used to create the
resources for our ``my-wordpress-site`` application.

First get the description of the template.

```execute
oc describe template/wordpress-classic-standalone
```

This will display what parameters the template accepts.

You can then look at the raw definition of the template by running:

```execute
oc get template wordpress-classic-standaloney -o yaml
```

