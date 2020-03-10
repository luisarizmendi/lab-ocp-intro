Before we start setting up the environment, oc command is installed in this system.

This workshop is running in a container that is using a project that will be created during the workshop. Please be aware that the workshop content pod, deployment config, route, etc is also contained in this project unless you create and use any other additional project (as we'll do during the first steps of the workshop). You can check the project that you are using running the following command:

```execute
oc project
```


{% if username == blank %}
Also take into account that, in the same way that the workshop is running in a predefined project, the user that you are running by default is not your user, is a serviceaccount, check it with:

```execute
oc whoami
```

If you want to use your own user you have to log in again (it will also be done as part of the first steps of this workshop)

{% endif %}

Regarding the Console tab, remember to change to your project since `default` project could be selected, in that case you will find a lot of "forbidden access" messages.</em>

<em>Note: Did you type the command in yourself? If you did, click on the command instead and you will find that it is executed for you. You can click on any command which has the <span class="fas fa-play-circle"></span> icon shown to the right of it, and it will be copied to the interactive terminal and run. If you would rather make a copy of the command so you can paste it to another window, hold down the shift key when you click on the command.
