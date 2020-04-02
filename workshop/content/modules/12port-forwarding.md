
{% if username == blank %}
  {% assign username = "user" %}
{% endif %}



Imaging that you need to check what's in the Database of the application that we already deployed, or that you need to inject values on it, in order to do that you can either connect directly to the database using `oc rsh` or you can just forward the database port to your local machine, let's review both ways

## Accessing the service accessing the POD

In order to know where the database is running to connect to, run the command:

```execute
oc get pods
```

This will output the details of the pod which is running the database (Guess what, is the one with the "-db").

```
NAME                            READY   STATUS      RESTARTS   AGE
my-wordpress-site-1-build       0/1     Completed   0          7m23s
my-wordpress-site-1-deploy      0/1     Completed   0          6m15s
my-wordpress-site-1-npbgb       1/1     Running     0          6m6s
my-wordpress-site-db-1-deploy   0/1     Completed   0          7m23s
my-wordpress-site-db-1-r6v8b    1/1     Running     0          7m14s
```

To make it easier to reference the name of the pod, capture the name of the pod in an environment variable by running:

```execute
POD=`oc get pods -o custom-columns=name:.metadata.name --no-headers | grep db | grep -v deploy`; echo $POD
```

To create an interactive shell within the same container running the database, you can use the ``oc rsh`` command, supplying it the name of the pod.

```execute
oc rsh $POD
```

You could also access an interactive terminal session via a web browser by visiting the pod details from the web console.

You can see that you are in the container running the database by running:

```execute
ps x
```

This will display output similar to:

```
    PID TTY      STAT   TIME COMMAND
      1 ?        Ssl    0:02 /opt/rh/rh-mysql57/root/usr/libexec/mysqld --defaults-file=/etc/my.cnf
    653 pts/0    Ss     0:00 /bin/sh
    674 pts/0    R+     0:00 ps x
```

Because you are in the same container, you could at this point run the database client for the database if provided in the container. For mysql, you would use the ``mysql`` command using the password configuring as a parameter when We deployed the application template.

```execute
mysql -uwpuser -predhat

```

This will present you with the prompt for running database operations via ``mysql``.

```
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 298
Server version: 5.7.24 MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

You could now dynamically create database tables, add data, or modify existing data.

To exit ``mysql`` enter:

```execute
\q
```

To exit the interactive shell run:

```execute
exit
```

Anything you want to do to the database could be be done through any database admin tool included in the container. This will though be limited to console based tools and you would not be able to use a GUI based tool which runs from your local machine as the database is still not exposed outside of the OpenShift cluster at this point.

If you need to run database script files to perform operations on the database, you would also need to first copy those files into the database container using the ``oc rsync`` command.

## Creating a remote connection

In order to access the database from a database administration tool running on your own local machine, it will be necessary to expose the database service outside of the OpenShift cluster.

When a web application is made visible outside of the OpenShift cluster a _Route_ is created. This enables a user to use a URL to access the web application from a web browser. A route is only usually used for web applications which use the HTTP protocol. A route cannot be used to expose a database as they would typically use their own distinct protocol and routes would not be able to work with the database protocol.

There are ways of permanently exposing a database service outside of an OpenShift cluster, however the need to do that would be an exception and not the norm. If only wanting to access the database to perform administration on it, you can instead create a temporary connection back to your local machine using port forwarding. The act of setting up port forwarding creates a port on your local machine which you can then use to connect to the database using a database administration tool.

To setup port forwarding between a local machine and the database running on OpenShift you use the ``oc port-forward`` command. You need to pass the name of the pod and details of the port the database service is using, as well as the local port to use.

The format for the command is:

```
oc port-forward <pod-name> <local-port>:<remote-port>
```

To create a connection to the PostgreSQL database, which uses port 3306, and expose it on the local machine where ``oc`` is being run, as port 13306, use:

```execute
oc port-forward $POD 13306:3306 &
```
(press Enter)

Port 13306 is used here for the local machine, rather than using 3306, in case an instance of PostgreSQL was also running on the local machine. If an instance of PostgreSQL was running on the local machine and the same port was used, setting up the connection would fail as the port would already be in use.

If you do not know what ports may be available, you can instead use the following format for the command:

```
oc port-forward <pod-name> :<remote-port>
```

In this form, the local port is left off, resulting in a random available port being used. You would need to look at the output from the command to work out what port number was used for the local port and use that.

When the ``oc port-forward`` command is run and the connection setup, it will stay running until the command is interrupted. You would then use a separate terminal window to run the administration tool which could connect via the forwarded connection. In this case, as we only have the one terminal window, we ran the ``oc port-forward`` command as a background job.

You can see that it is still running using:

```execute
jobs
```

With the port forwarding in place, you can now run ``mysql`` again. This time it is being run from the local machine, and not inside of the container. Because the forwarded connection is using port 13306 on the local machine, you need to explicitly tell it to use that port rather than the default database port.

```execute
mysql -uwpuser -predhat --host=127.0.0.1 --port=13306
```

This will again present you with the prompt for running database operations via ``mysql``.

```
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 298
Server version: 5.7.24 MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

You could now dynamically create database tables, add data, or modify existing data.

To exit ``mysql`` enter:

```execute
\q
```

Because we ran the ``oc port-forward`` command as a background process, we can kill it when done using:

```execute
kill %1
```

Running ``jobs`` again we can see it is terminated.

```execute
jobs
```

In this exercise we used ``mysql``, however you could also use a GUI based database administration tool running on your local machine as well.
