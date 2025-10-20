# Instructions to validate the Kubernetes deployment

All commands assume the namespace `todoapp`.

---

## 1. Identify a running pod automatically

Use this command to get the name of a running pod with the main app:


    POD=$(kubectl get pods -n todoapp -l app=todoapp -o jsonpath='{.items[0].metadata.name}')
    echo "Using pod: $POD"

## 2. Verify that the application is running
Check pod status:


    kubectl get pods -n todoapp
You should see STATUS=Running and READY=1/1 (or correct count for multi-container pods).

Check logs to ensure the app started successfully:

    kubectl logs $POD -n todoapp

## 3. Verify PVC-backed mount at /app/data
Exec into the pod:

    kubectl exec -it $POD -n todoapp -- /bin/sh
Navigate to the PV mount path:

    cd /app/data
    ls -l
Create a test file and verify persistence:

    echo "hello" > test.txt
    cat test.txt
Exit pod, delete it, and verify that the file persists:

    kubectl delete pod $POD -n todoapp
    POD=$(kubectl get pods -n todoapp -l app=todoapp -o jsonpath='{.items[0].metadata.name}')
    kubectl exec -it $POD -n todoapp -- cat /app/data/test.txt
If you see hello, PVC is working correctly.

## 4. Verify ConfigMap mount is read-only
Exec into the pod:

    kubectl exec -it $POD -n todoapp -- /bin/sh
Navigate to the ConfigMap mount path:

    cd /app/configs
    ls -l
You should see files corresponding to all keys in configMap.yml.
List keys from Kubernetes for verification:

    kubectl get configmap app-config -n todoapp -o jsonpath='{.data}' 
Test that the mount is read-only:

    echo "test" > testfile.txt
Should fail with "Read-only file system"

## 5. Verify Secret mount is read-only
Navigate to the Secret mount path (adjust if different):

    cd /app/secrets
    ls -l
You should see files corresponding to all keys in secret.yml.
List keys from Kubernetes for verification:

    kubectl get secret app-secret -n todoapp -o jsonpath='{.data}' 

Test that the mount is read-only:

    echo "test" > testfile.txt
Should fail with "Read-only file system"