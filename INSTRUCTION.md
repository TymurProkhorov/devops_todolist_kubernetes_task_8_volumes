## Instructions to validate the todoapp-deployment

### Verify that the application is running

Check that all pods in the `todoapp` namespace are running:

    kubectl get pods -n todoapp
You should see all pods with STATUS = Running and READY = 1/1 (or appropriate count if multiple containers).


## Validate that ConfigMap data is mounted as file

### 1. Exec into a running pod:

    kubectl exec -it $(kubectl get pods -n todoapp -l app=kube2py -o jsonpath='{.items[0].metadata.name}') -n todoapp -- /bin/sh

### 2. Navigate to the mount path for the ConfigMap

    cd /app/configs
    ls -l

You should see files corresponding to the keys in your ConfigMap.

### 3. Check that the file contents match the values in your ConfigMap:
    cat PYTHONUNBUFFERED
Repeat for all files to verify they are mounted in the correct order if order matters.


## Validate that Secrets is mounted as files

### 1. Exec into a running pod:

    kubectl exec -it <pod-name> -n todoapp -- /bin/sh

### 2. Navigate to the mount path for the Secret

    cd /app/secrets
    ls -l

You should see files corresponding to the keys in your secret.

### 3. Check that the file contents match the values in your Secret:
    cat SECRET_KEY
