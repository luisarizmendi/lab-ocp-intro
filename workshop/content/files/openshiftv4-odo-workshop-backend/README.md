# Concession-kiosk-Back-End

This is the Back-End component for the concession kiosk application. The Back-End is written using Node.js and Express and will serve as the intermediary between the frontend and the database.

# How to Deploy on OpenShift

```
oc new-project concession-kiosk
oc new-app https://github.com/jankleinert/concession-kiosk-backend --name backend
```

To link the frontend and Back-End components, you'll provide the Back-End service name (backend) and port (8080) to the frontend as environment variables.


