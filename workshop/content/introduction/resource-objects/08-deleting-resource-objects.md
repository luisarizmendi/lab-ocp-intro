If you need to delete an entire application, or just a single resource, you can use the ``oc delete`` command. Specific resource objects can be deleted by their names, or by matching on a subset of resource objects using labels.

To delete a single resource object by name supply the name:

```execute
oc delete route/parksmap-fqdn
```

To delete all resources objects of a specific type using labels, supply the resource object type name and the selector.

```execute
oc delete route --selector app=parksmap
```

When using a label selector, you can list more than one resource object type name by separating them with a comma.

```execute
oc delete svc,route --selector app=parksmap
```

The short cut of ``all`` can also be used to match all key resource objects types that are directly associated with the build and deployment of an application.

```execute
oc delete all --selector app=parksmap
```

It is recommended that before deleting any resource objects, you use ``oc get`` with the same parameters to confirm what would be deleted. This is especially important with a final variant of the ``oc delete all`` command. That is, where no selector is provided.

In this case, all matched resource objects in the project would be deleted. Because the danger is there of accidentally deleting all your work, it is necessary to also supply the ``--all`` option to confirm that you do really wish to delete all resources objects from the project.

```execute
oc delete all --all
```
