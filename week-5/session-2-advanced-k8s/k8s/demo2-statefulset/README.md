# Kubernetes StatefulSet Demo - Persistent Notes Application

A hands-on demonstration of Kubernetes StatefulSet with persistent storage using a Python-based notes application.

## 📋 Overview

This project demonstrates how Kubernetes StatefulSets work by deploying a simple notes application where each pod maintains its own persistent storage. The data persists even when pods are restarted or rescheduled.

## 🏗️ Architecture

```
LoadBalancer Service (Port 80)
          ↓
    StatefulSet (3 replicas)
          ↓
   ┌──────┬──────┬──────┐
   │      │      │      │
demo2-0  demo2-1  demo2-2
   │      │      │      │
 PVC-0   PVC-1   PVC-2  (1Gi each)
```

Each pod has:

- Python 3.11 HTTP server
- Persistent volume for storing notes
- Unique persistent storage that survives restarts

## 📁 Project Files

```
demo2-statefulset/
├── README.md           # This documentation
├── configmap.yaml      # Application code (Python + HTML)
├── statefulset.yaml    # StatefulSet definition + Namespace
└── service.yaml        # LoadBalancer service
```

## 🔧 Prerequisites

Before you begin, ensure you have:

- ✅ Kubernetes cluster (v1.19+)
- ✅ `kubectl` CLI installed and configured
- ✅ Sufficient cluster resources (3 pods × 256Mi RAM)
- ✅ Storage provisioner for PersistentVolumes (or pre-provisioned PVs)
- ✅ LoadBalancer support (cloud provider or MetalLB for on-prem)

### Verify kubectl is working:

```bash
kubectl version --short
kubectl cluster-info
```

## 🚀 Quick Start

### Step 1: Clone or Download the Files

Ensure you have all three YAML files in the same directory:

```bash
ls -la
# You should see:
# configmap.yaml
# statefulset.yaml
# service.yaml
```

### Step 2: Deploy the Application

Apply the resources in the following order:

```bash
# 1. Create the namespace and StatefulSet
kubectl apply -f statefulset.yaml

# 2. Create the ConfigMap with application code
kubectl apply -f configmap.yaml

# 3. Create the LoadBalancer service
kubectl apply -f service.yaml
```

Or apply everything at once:

```bash
kubectl apply -f .
```

### Step 3: Verify Deployment

Check if all resources are created:

```bash
# Check namespace
kubectl get namespace demo2-statefulset

# Check all resources in the namespace
kubectl get all -n demo2-statefulset

# Check StatefulSet status
kubectl get statefulset -n demo2-statefulset

# Check pods
kubectl get pods -n demo2-statefulset

# Check PVCs
kubectl get pvc -n demo2-statefulset

# Check service
kubectl get svc -n demo2-statefulset
```

Expected output:

```
NAME                READY   STATUS    RESTARTS   AGE
pod/demo2-0         1/1     Running   0          2m
pod/demo2-1         1/1     Running   0          2m
pod/demo2-2         1/1     Running   0          1m

NAME                    TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
service/demo2-service   LoadBalancer   10.96.123.45    <pending>       80:30123/TCP   2m

NAME                     READY   AGE
statefulset.apps/demo2   3/3     2m
```

### Step 4: Wait for Pods to be Ready

Monitor pod status:

```bash
kubectl get pods -n demo2-statefulset -w
# Press Ctrl+C to stop watching
```

Wait until all pods show `1/1 READY` and `Running` status.

### Step 5: Get the Service External IP

```bash
kubectl get svc demo2-service -n demo2-statefulset
```

**For Cloud Providers (AWS/GCP/Azure):**
Wait for `EXTERNAL-IP` to show a public IP address (may take 1-2 minutes)

**For Minikube:**

```bash
minikube service demo2-service -n demo2-statefulset
```

**For Kind or Docker Desktop:**

```bash
kubectl port-forward svc/demo2-service 8080:80 -n demo2-statefulset
# Then access: http://localhost:8080
```

### Step 6: Access the Application

Open your browser and navigate to:

- **Cloud:** `http://<EXTERNAL-IP>`
- **Port-forward:** `http://localhost:8080`

You should see the **Persistent Notes App** interface! 🎉

## 📝 Using the Application

### Application Features

1. **Write Notes** - Type in the textarea
2. **Save Notes** - Click "Save Notes" button (or wait 30 seconds for auto-save)
3. **Reload Notes** - Click "Reload Notes" to fetch saved data
4. **Clear Notes** - Click "Clear" to empty the textarea
5. **Pod Information** - View which pod you're connected to

### Testing Persistence

Let's verify that data persists across pod restarts:

#### Test 1: Write and Save Notes

```bash
# 1. Access the application in your browser
# 2. Write some text: "This is a test message - Pod 0"
# 3. Click "Save Notes"
```

#### Test 2: Delete a Pod

```bash
# Delete the first pod
kubectl delete pod demo2-0 -n demo2-statefulset

# Watch it recreate
kubectl get pods -n demo2-statefulset -w
```

#### Test 3: Verify Data Persisted

```bash
# Wait for demo2-0 to be Running again
# Refresh your browser
# Your notes should still be there! ✅
```

#### Test 4: Access Different Pods

```bash
# Port forward to specific pods to see their individual storage

# Pod 0
kubectl port-forward pod/demo2-0 8080:8080 -n demo2-statefulset
# Open: http://localhost:8080 - Write "Notes from Pod 0"

# Pod 1 (in a new terminal)
kubectl port-forward pod/demo2-1 8081:8080 -n demo2-statefulset
# Open: http://localhost:8081 - Write "Notes from Pod 1"

# Each pod has its own storage! 🎯
```

## 🔍 Monitoring and Debugging

### View Pod Logs

```bash
# View logs from a specific pod
kubectl logs demo2-0 -n demo2-statefulset

# Follow logs in real-time
kubectl logs -f demo2-0 -n demo2-statefulset

# View logs from all pods
kubectl logs -l app=demo2 -n demo2-statefulset
```

### Check Pod Details

```bash
# Describe a pod
kubectl describe pod demo2-0 -n demo2-statefulset

# Check resource usage
kubectl top pod -n demo2-statefulset
```

### Inspect PersistentVolumeClaims

```bash
# List all PVCs
kubectl get pvc -n demo2-statefulset

# Describe a specific PVC
kubectl describe pvc data-demo2-0 -n demo2-statefulset

# Check associated PersistentVolumes
kubectl get pv
```

### Execute Commands Inside Pods

```bash
# Shell into a pod
kubectl exec -it demo2-0 -n demo2-statefulset -- /bin/sh

# Check the notes file
kubectl exec demo2-0 -n demo2-statefulset -- cat /data/notes/notes.txt

# List mounted volumes
kubectl exec demo2-0 -n demo2-statefulset -- df -h
```

### Check StatefulSet Status

```bash
# Get StatefulSet details
kubectl describe statefulset demo2 -n demo2-statefulset

# Check events
kubectl get events -n demo2-statefulset --sort-by='.lastTimestamp'
```

## 🔧 Configuration

### Modify Replicas

Edit the StatefulSet to change the number of replicas:

```bash
# Scale up to 5 replicas
kubectl scale statefulset demo2 --replicas=5 -n demo2-statefulset

# Scale down to 2 replicas
kubectl scale statefulset demo2 --replicas=2 -n demo2-statefulset

# Check status
kubectl get pods -n demo2-statefulset
```

### Update the Application Code

If you want to modify the Python code or HTML:

1. Edit `configmap.yaml`
2. Apply changes:

```bash
kubectl apply -f configmap.yaml
```

3. Restart pods to pick up changes:

```bash
kubectl rollout restart statefulset demo2 -n demo2-statefulset
```

### Change Storage Size

Edit `statefulset.yaml` and modify the `volumeClaimTemplates` section:

```yaml
resources:
  requests:
    storage: 2Gi # Change from 1Gi to 2Gi
```

⚠️ **Note:** You cannot resize existing PVCs for running pods. You'll need to:

1. Delete the StatefulSet
2. Delete the PVCs
3. Apply the updated configuration

## 🧪 Common Operations

### Restart All Pods

```bash
kubectl rollout restart statefulset demo2 -n demo2-statefulset
```

### View Rollout Status

```bash
kubectl rollout status statefulset demo2 -n demo2-statefulset
```

### Update ConfigMap and Restart

```bash
kubectl apply -f configmap.yaml
kubectl rollout restart statefulset demo2 -n demo2-statefulset
```

### Check Service Endpoints

```bash
kubectl get endpoints demo2-service -n demo2-statefulset
```

## 🧹 Cleanup

### Remove All Resources

To delete everything:

```bash
# Delete all resources in the namespace
kubectl delete -f service.yaml
kubectl delete -f statefulset.yaml
kubectl delete -f configmap.yaml

# Or delete the entire namespace (removes everything)
kubectl delete namespace demo2-statefulset
```

### Keep Data, Remove Pods

To remove pods but keep PVCs:

```bash
kubectl delete statefulset demo2 -n demo2-statefulset --cascade=orphan
```

### Delete Specific Resources

```bash
# Delete only the service
kubectl delete svc demo2-service -n demo2-statefulset

# Delete only the StatefulSet (keeps PVCs)
kubectl delete statefulset demo2 -n demo2-statefulset

# Delete specific PVC
kubectl delete pvc data-demo2-0 -n demo2-statefulset
```

## ❓ Troubleshooting

### Pods are Pending

**Problem:** Pods stuck in `Pending` state

**Solution:**

```bash
# Check pod events
kubectl describe pod demo2-0 -n demo2-statefulset

# Common issues:
# 1. No storage provisioner
kubectl get sc  # Check StorageClass

# 2. Insufficient resources
kubectl describe nodes

# 3. PVC not bound
kubectl get pvc -n demo2-statefulset
```

### Service Has No External IP

**Problem:** LoadBalancer shows `<pending>` for EXTERNAL-IP

**Solution:**

```bash
# If using Minikube
minikube tunnel  # Run in separate terminal

# If using Kind/Docker Desktop
# Use port-forward instead:
kubectl port-forward svc/demo2-service 8080:80 -n demo2-statefulset

# If on bare-metal, install MetalLB or use NodePort:
kubectl edit svc demo2-service -n demo2-statefulset
# Change type: LoadBalancer to type: NodePort
```

### Cannot Access Application

**Problem:** Browser shows connection refused

**Solution:**

```bash
# 1. Check pods are running
kubectl get pods -n demo2-statefulset

# 2. Check service endpoints
kubectl get endpoints demo2-service -n demo2-statefulset

# 3. Test from within cluster
kubectl run test --rm -it --image=busybox -n demo2-statefulset -- wget -O- http://demo2-service

# 4. Check pod logs for errors
kubectl logs demo2-0 -n demo2-statefulset
```

### Notes Not Persisting

**Problem:** Data is lost after pod restart

**Solution:**

```bash
# 1. Check PVC is bound
kubectl get pvc -n demo2-statefulset

# 2. Verify volume is mounted
kubectl exec demo2-0 -n demo2-statefulset -- df -h

# 3. Check file exists
kubectl exec demo2-0 -n demo2-statefulset -- ls -la /data/notes/

# 4. Verify PV reclaim policy
kubectl get pv
```

### Pod CrashLoopBackOff

**Problem:** Pods keep restarting

**Solution:**

```bash
# Check logs
kubectl logs demo2-0 -n demo2-statefulset

# Check previous logs
kubectl logs demo2-0 -n demo2-statefulset --previous

# Common causes:
# - ConfigMap not applied
# - Python syntax error
# - Port already in use
```

## 📚 Understanding StatefulSets

### Key Concepts

1. **Stable Network Identity**
   - Each pod gets a predictable name: `demo2-0`, `demo2-1`, `demo2-2`
   - Names remain stable across restarts

2. **Persistent Storage**
   - Each pod gets its own PVC
   - PVCs are not deleted when pods are deleted
   - Data persists across pod restarts

3. **Ordered Deployment**
   - Pods are created sequentially: 0, then 1, then 2
   - Each waits for the previous to be Running

4. **Ordered Termination**
   - Pods are deleted in reverse order: 2, then 1, then 0

### StatefulSet vs Deployment

| Feature    | StatefulSet              | Deployment            |
| ---------- | ------------------------ | --------------------- |
| Pod naming | Predictable (demo2-0)    | Random (demo2-abc123) |
| Storage    | Per-pod persistent       | Shared or ephemeral   |
| Order      | Sequential               | Parallel              |
| Use case   | Databases, stateful apps | Stateless apps        |

## 🎯 Learning Objectives

After completing this demo, you should understand:

- ✅ How to deploy a StatefulSet
- ✅ How persistent volumes work with StatefulSets
- ✅ How to expose StatefulSets via LoadBalancer
- ✅ How data persists across pod restarts
- ✅ How to scale StatefulSets
- ✅ How to debug Kubernetes applications
- ✅ How ConfigMaps store application code

## 🔗 Additional Resources

- [Kubernetes StatefulSets Documentation](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Services](https://kubernetes.io/docs/concepts/services-networking/service/)

## 📞 Support

If you encounter issues:

1. Check the Troubleshooting section above
2. Review pod logs: `kubectl logs <pod-name> -n demo2-statefulset`
3. Check Kubernetes events: `kubectl get events -n demo2-statefulset`

## 📝 Notes

- This is a **demo application** - not production-ready
- The Python HTTP server is simple and single-threaded
- Each pod maintains its own independent storage
- Auto-save runs every 30 seconds
- The application uses Python 3.11-slim image (~50MB)

## 🏆 Success Criteria

You've successfully completed the demo if you can:

- ✅ Deploy all resources without errors
- ✅ Access the application through the service
- ✅ Write and save notes
- ✅ Delete a pod and verify data persists
- ✅ Access different pods and see independent storage
- ✅ Scale the StatefulSet up and down

---

**Happy Learning! 🚀**

If this demo helped you understand StatefulSets, consider sharing it with others!
