
{% if username == blank %}
  {% assign username = user %}
{% endif %}


We have seen how we can change the code and then the content on the POD will be changed when using S2I, but What if I want to run a quick test before making changes to the code?, for example uploading a File to the POD, or What if I can check the file created by the Source Code? (Downloading a File), let's review how we can do that.

## Downloading Files from a POD


```execute
oc get pods --selector deploymentconfig=blog-django-py
```

You only have one instance of the application so only one pod will be listed, similar to:

```
NAME           READY     STATUS    RESTARTS   AGE
blog-1-9j3p3   1/1       Running   0          1m
```

For subsequent commands which need to interact with that pod, you will need to use the name of the pod, as an argument.

To make it easier to reference the name of the pod in these instructions, we define here a shell function to capture the name so it can be stored in an environment variable. That environment variable will then be used in the commands you run.

The command we will run from the shell function to get out just the name of the pod will be:

```execute
oc get pods --selector deploymentconfig=blog-django-py -o jsonpath='{.items[?(@.status.phase=="Running")].metadata.name}'
```

As above this uses ``oc get pods`` with a label selector, but we also use a ``jsonpath`` query to extract the name of the running pod.

To create the shell function run:

```execute
pod() { local selector=$1; local query='?(@.status.phase=="Running")'; oc get pods --selector $selector -o jsonpath="{.items[$query].metadata.name}"; }
```

To capture the name of the pod for this application in the ``POD`` environment variable, run:

```execute
POD=`pod deploymentconfig=blog-django-py`; echo $POD
```

To create an interactive shell within the same container running the application, you can use the ``oc rsh`` command, supplying it the environment variable holding the name of the pod.

```execute
oc rsh $POD
```

From within the interactive shell, see what files exist in the application directory.

```execute
ls -las
```

This will yield output similar to:

```
total 80
 0 drwxrwxr-x. 1 default    root    52 Oct 24 02:51 .
 0 drwxrwxr-x. 1 default    root    28 Jun 18 02:10 ..
 4 -rwxrwxr-x. 1 default    root  1454 Jun 18 02:07 app.sh
 0 drwxrwxr-x. 1 default    root    43 Jun 18 02:11 blog
 0 drwxrwxr-x. 2 default    root    25 Jun 18 02:07 configs
 4 -rw-rw-r--. 1 default    root   230 Jun 18 02:07 cronjobs.py
44 -rw-r--r--. 1 1000520000 root 44032 Oct 24 02:51 db.sqlite3
 4 -rw-rw-r--. 1 default    root   430 Jun 18 02:07 Dockerfile
 0 drwxrwxr-x. 2 default    root    25 Jun 18 02:07 htdocs
 0 drwxrwxr-x. 1 default    root    25 Jun 18 02:11 katacoda
 4 -rwxrwxr-x. 1 default    root   806 Jun 18 02:07 manage.py
 0 drwxrwxr-x. 3 default    root    20 Jun 18 02:11 media
 0 drwxrwxr-x. 1 default    root    19 Apr  3  2019 .pki
 4 -rw-rw-r--. 1 default    root   832 Jun 18 02:07 posts.json
 8 -rw-rw-r--. 1 default    root  7861 Jun 18 02:07 README.md
 4 -rw-rw-r--. 1 default    root   203 Jun 18 02:07 requirements.txt
 4 -rw-rw----. 1 default    root  1024 Apr  3  2019 .rnd
 0 drwxrwxr-x. 4 default    root    57 Jun 18 02:09 .s2i
 0 drwxrwxr-x. 4 default    root    30 Jun 18 02:11 static
 0 drwxrwxr-x. 2 default    root   148 Jun 18 02:07 templates
```

For the application being used, this has created a database file:

```
44 -rw-r--r--. 1 1000520000 root 44032 Oct 24 02:51 db.sqlite3
```

Lets look at how this database file can be copied back to the local machine.

To confirm what directory the file is located in, inside of the container, run:

```execute
pwd
```

This should display:

```
/opt/app-root/src
```

To exit the interactive shell and return to the local machine run:

```execute
exit
```

To copy files from the container to the local machine the ``oc rsync`` command can be used.

The form of the command when copying a single file from the container to the local machine is:

```
oc rsync <pod-name>:/remote/dir/filename ./local/dir
```

To copy the single database file run:

```execute
oc rsync $POD:/opt/app-root/src/db.sqlite3 .
```

This should display output similar to:

```
receiving incremental file list
db.sqlite3

sent 43 bytes  received 44,129 bytes  88,344.00 bytes/sec
total size is 44,032  speedup is 1.00
```

Check the contents of the current directory by running:
```execute
ls -las
```

and you should see that the local machine now has a copy of the file.

```
44 -rw-r--r--  1 root root 44032 Oct 24 04:15 db.sqlite3
```

Note that the local directory into which you want the file copied must exist. If you didn't want to copy it into the current directory, ensure the target directory has been created beforehand.

In addition to copying a single file, a directory can also be copied. The form of the command when copying a directory to the local machine is:

```
oc rsync <pod-name>:/remote/dir ./local/dir
```

To copy the ``media`` directory from the container, run:

```execute
oc rsync $POD:/opt/app-root/src/media .
```

If you wanted to rename the directory when it is being copied, you should create the target directory with the name you want to use first.

```execute
mkdir uploads
```

and then to copy the files use the command:

```execute
oc rsync $POD:/opt/app-root/src/media/. uploads
```

To ensure only the contents of the directory on the container are copied, and not the directory itself, the remote directory is suffixed with ``/.``.

Note that if the target directory contains existing files with the same name as a file in the container, the local file will be overwritten. If there are additional files in the target directory which don't exist in the container, those files will be left as is. If you did want an exact copy, where the target directory was always updated to be exactly the same as what exists in the container, use the ``--delete`` option to ``oc rsync``.

When copying a directory, you can be more selective about what is copied by using the ``--exclude`` and ``--include`` options to specify patterns to be matched against directories and files, with them being excluded or included as appropriate.

If there is more than one container running within a pod, you will need to specify which container you want to work with by using the ``--container`` option.


## Uploading Files to a POD

To copy files from the local machine to the container, the ``oc rsync`` command is again used.

The form of the command when copying files from the local machine to the container is:


```
oc rsync ./local/dir <pod-name>:/remote/dir
```

Unlike when copying from the container to the local machine, there is no form for copying a single file. To copy selected files only, you will need to use the ``--exclude`` and ``--include`` options to filter what is and isn't copied from a specified directory.

To illustrate the process for copying a single file, consider the case where you had deployed a web site and had not included a ``robots.txt`` file, but needed to quickly stop a web robot which was crawling your site.

A request to fetch the current ``robots.txt`` file for the web site fails with a HTTP ``404 Not Found`` response.

```execute
curl --head http://blog-lab-intro-{{ username }}.{{ cluster_subdomain }}/robots.txt
```

Create a ``robots.txt`` file to upload.

```execute
cat > robots.txt << !
User-agent: *
Disallow: /
!
```

For the web application being used, it hosts static files out of the ``htdocs`` sub directory of the application source code. To upload the ``robots.txt`` file run:

```execute
oc rsync . $POD:/opt/app-root/src/htdocs --exclude=* --include=robots.txt --no-perms
```

As already noted it is not possible to copy a single file, so we indicate that the current directory should be copied, but use the ``--exclude=*`` option to first say that all files should be ignored when performing the copy. That pattern is then overridden for just the ``robots.txt`` file by using the ``--include=robots.txt`` file, ensuring the ``robots.txt`` file is copied.

When copying files to the container, it is required that the directory into which files are being copied exists, and that it is writable to the user or group that the container is being run as. Permissions on directories and files should be set as part of the process of building the image.

In the above command, the ``--no-perms`` option is also used because the target directory in the container, although writable by the group the container is run as, is owned by a different user to that which the container is run as. This means that although files can be added to the directory, permissions on existing directories cannot be changed. The ``--no-perms`` options tells ``oc rsync`` to not attempt to update permissions to avoid it failing and returning errors.

Having uploaded the ``robots.txt`` file, fetching the ``robots.txt`` file again now succeeds.

```execute
curl http://blog-lab-intro-{{ username }}.{{ cluster_subdomain }}/robots.txt
```

This worked without needing to take any further actions as the Apache HTTPD server being used to host static files, would automatically detect the presence of a new file in the directory.

If instead of copying a single file you wanted to copy a complete directory, leave off the ``--include`` and ``--exclude`` options. To copy the complete contents of the current directory to the ``htdocs`` directory in the container, run:

```execute
oc rsync . $POD:/opt/app-root/src/htdocs --no-perms
```

Just be aware that this will be everything, including notionally hidden files or directories starting with ".". You should therefore be careful, and if necessary be more specific by using ``--include`` or ``--exclude`` options to limit the set of files or directories copied.


## Sync Files with a POD

In addition to being able to manually upload or download files when you choose to, the ``oc rsync`` command can also be set up to perform live synchronization of files between your local computer and the container.

That is, the file system of your local computer will be monitored for any changes made to files. When there is a change to a file, the changed file will be automatically copied up to the container.

This same process can also be run in the opposite direction if required, with changes made in the container being automatically copied back to your local computer.

An example of where it can be useful to have changes automatically copied from your local computer into the container is during the development of an application.

For scripted programming languages such as PHP, Python or Ruby, where no separate compilation phase is required, provided that the web server can be manually restarted without causing the container to exit, or if the web server always reloads code files which have been modified, you can perform live code development with your application running inside of OpenShift.

To demonstrate this ability, clone the Git repository for the web application which you have already deployed.

```execute
cd ~
mkdir rsync
cd rsync
git clone https://github.com/openshift-katacoda/blog-django-py
```

This will create a sub directory ``blog-django-py`` containing the source code for the application:

```
Cloning into 'blog-django-py'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 412 (delta 0), reused 0 (delta 0), pack-reused 409
Receiving objects: 100% (412/412), 68.49 KiB | 701.00 KiB/s, done.
Resolving deltas: 100% (200/200), done.
```

Now run the following command to have ``oc rsync`` perform live synchronisation of the code, copying any changes from the ``blog-django-py`` directory up to the container.

```execute
oc rsync blog-django-py/. $POD:/opt/app-root/src --no-perms --watch &
```

In this case we are running this as a background process as we only have the one terminal window available, you could run it as a foreground process in a separate terminal if doing this yourself.

You can see the details for the background process by running:

```execute
jobs
```

When you initially ran this ``oc rsync`` command, you will see that it copied up the files so the local and remote directory are synchronized. Any changes made to the local files will now be automatically copied up to the remote directory.

Before we make a change, bring up the web application we have deployed in a separate browser window by using the URL:

http://blog-lab-intro-{{ username }}.{{ cluster_subdomain }}/

You should see that the color of the title banner for the web site is red.

![Blog Web Site Red](../../assets/introduction/transferring-files-42/04-blog-web-site-red.png)

Lets change that banner color by running the command:

```execute
echo "BLOG_BANNER_COLOR = 'blue'" >> blog-django-py/blog/context_processors.py
```

Wait to see that the changed file is uploaded, and then refresh the page for the web site.

Unfortunately you will see that the title banner is still red. This is because for Python any code changes are cached by the running process and it is necessary to restart the web server application processes.

For this deployment the WSGI server ``mod_wsgi-express`` is being used. To trigger a restart of the web server application processes, run:

```execute
oc rsh $POD kill -HUP 1
```

This command will have the affect of sending a HUP signal to process ID 1 running within the container, which is the instance of ``mod_wsgi-express`` which is running. This will trigger the required restart and reloading of the application, but without the web server actually exiting.

Refresh the page for the web site once more and the title banner should now be blue.

![Blog Web Site Blue](../../assets/introduction/transferring-files-42/04-blog-web-site-blue.png)

Note that the name of the pod as displayed in the title banner is unchanged, indicating that the pod was not restarted and only the web server application processes were restarted.

Manually forcing a restart of the web server application processes will get the job done, but a better way is if the web server can automatically detect code changes and trigger a restart.

In the case of ``mod_wsgi-express`` and how this web application has been configured, this can be enabled by setting an environment variable for the deployment. To set this environment variable run:

```execute
oc set env dc/blog MOD_WSGI_RELOAD_ON_CHANGES=1
```

This command will update the deployment configuration, shutdown the existing pod and replace it with a new instance of our application with the environment variable now being passed through to the application.

Monitor the re-deployment of the application by running:

```execute
oc rollout status dc/blog
```

Because the existing pod has been shutdown, we will need to capture again the new name for the pod.

```execute
POD=`pod app=blog`; echo $POD
```

You may also notice that the synchronization process we had running in the background may have stopped. This is because the pod it was connected to had been shutdown.

You can check this is the case by running:

```execute
jobs
```

If it is still showing as running, due to shutdown of the pod not yet having been detected, run:

```execute
kill -9 %1
```

to kill it.

Ensure the background task has exited:

```execute
jobs
```

Now run the ``oc rsync`` command again, against the new pod.

```execute
oc rsync blog-django-py/. $POD:/opt/app-root/src --no-perms --watch &
```

Refresh the page for the web site again and the title banner should still be blue, but you will notice that the pod name displayed has changed.

Modify the code file once more, setting the color to green.

```execute
echo "BLOG_BANNER_COLOR = 'green'" >> blog-django-py/blog/context_processors.py
```

Refresh the web site page again, multiple times if need be, until the title banner shows as green. The change may not be immediate as the file synchronization may take a few moments, as may the detection of the code changes and restart of the web server application process.

![Blog Web Site Green](../../assets/introduction/transferring-files-42/04-blog-web-site-green.png)

Kill the synchronization task by running:

```execute
kill -9 %1
```

Although one can synchronize files from the local computer into a container in this way, whether you can use it as a mechanism for enabling live coding will depend on the programming language being used, and the web application stack being used. This was possible for Python when using ``mod_wsgi-express``, but may not be possible with other WSGI servers for Python, or other programming languages.

Do note that even for the case of Python, this can only be used where modifying code files. If you need to install additional Python packages, you would need to re-build the application from the original source code. This is because changes to packages required, which for Python is given in the ``requirements.txt`` file, isn't going to trigger the installation of that package when using this mechanism.



## Copy Files to a Persistent Volume

If you are mounting a persistent volume into the container for your application and you need to copy files into it, then ``oc rsync`` can be used in the same way as described previously to upload files. All you need to do is supply as the target directory, the path of where the persistent volume is mounted in the container.

If you haven't as yet deployed your application, but are wanting to prepare in advance a persistent volume with all the data it needs to contain, you can still claim a persistent volume and upload the data to it. In order to do this, you will though need to deploy a dummy application against which the persistent volume can be mounted.

To create a dummy application for this purpose run the command:

```execute
oc run dummy --image centos/httpd-24-centos7
```

We use the ``oc run`` command as it creates just a deployment configuration and managed pod. A service is not created as we don't actually need the application we are running here, an instance of the Apache HTTPD server in this case, to actually be contactable. We are using the Apache HTTPD server purely as a means of keeping the pod running.

To monitor the startup of the pod and ensure it is deployed, run:

```execute
oc rollout status dc/dummy
```

Once it is running, you can see the more limited set of resources created, as compared to what would be created when using ``oc new-app``, by running:

```execute
oc get all --selector run=dummy -o name
```

Now that we have a running application, we next need to claim a persistent volume and mount it against our dummy application. When doing this we assign it a claim name of ``data`` so we can refer to the claim by a set name later on. We mount the persistent volume at ``/mnt`` inside of the container, the traditional directory used in Linux systems for temporarily mounting a volume.

```execute
oc set volume dc/dummy --add --name=tmp-mount --claim-name=data --type pvc --claim-size=1G --mount-path /mnt
```

This will cause a new deployment of our dummy application, this time with the persistent volume mounted. Again monitor the progress of the deployment so we know when it is complete, by running:

```execute
oc rollout status dc/dummy
```

To confirm that the persistent volume claim was successful, you can run:

```execute
oc get pvc
```

With the dummy application now running, and with the persistent volume mounted, capture the name of the pod for the running application.

```execute
POD=`pod run=dummy`; echo $POD
```

We can now copy any files into the persistent volume, using the ``/mnt`` directory where we mounted the persistent volume, as the target directory. In this case since we are doing a one off copy, we can use the ``tar`` strategy instead of the ``rsync`` strategy.

```execute
oc rsync ./ $POD:/mnt --strategy=tar
```

When complete, you can validate that the files were transferred by listing the contents of the target directory inside of the container.

```execute
oc rsh $POD ls -las /mnt
```

If you were done with this persistent volume and perhaps needed to repeat the process with another persistent volume and with different data, you can unmount the persistent volume but retain the dummy application.

```execute
oc set volume dc/dummy --remove --name=tmp-mount
```

Monitor the process once again to confirm the re-deployment has completed.

```execute
oc rollout status dc/dummy
```

Capture the name of the current pod again:

```execute
POD=`pod run=dummy`; echo $POD
```

and look again at what is in the target directory. It should be empty at this point. This is because the persistent volume is no longer mounted and you are looking at the directory within the local container file system.

```execute
oc rsh $POD ls -las /mnt
```

If you already have an existing persistent volume claim, as we now do, you could mount the existing claimed volume against the dummy application instead. This is different to above where we both claimed a new persistent volume and mounted it to the application at the same time.

```execute
oc set volume dc/dummy --add --name=tmp-mount --claim-name=data --mount-path /mnt
```

Look for completion of the re-deployment:

```execute
oc rollout status dc/dummy
```

Capture the name of the pod:

```execute
POD=`pod run=dummy`; echo $POD
```

and check the contents of the target directory. The files we copied to the persistent volume should again be visible.

``oc rsh $POD ls -las /mnt
```

When done and you want to delete the dummy application, use ``oc delete`` to delete it, using a label selector of ``run=dummy`` to ensure we only delete the resource objects related to the dummy application.

```execute
oc delete all --selector run=dummy
```

Check that all the resource objects have been deleted.

```execute
oc get all --selector run=dummy -o name
```

Although we have deleted the dummy application, the persistent volume claim still exists and can later be mounted against your actual application to which the data belongs.

```execute
oc get pvc
```
