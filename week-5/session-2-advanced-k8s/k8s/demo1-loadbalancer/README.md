# Demo 1: Nginx with LoadBalancer Service

This demo deploys Nginx with a simple LoadBalancer service for external access in the `demo1-loadbalancer` namespace.

## Namespace

All resources are deployed in the `demo1-loadbalancer` namespace for isolation.

## Files Overview

### nginx-deployment.yaml

- 3 replicas of Nginx pods
- Resource limits and requests configured
- No persistent storage

### nginx-service.yaml

- Service type: LoadBalancer
- Exposes Nginx on port 80
- CreatCreate Namespace

```bash
kubectl apply -f namespace.yaml
```

### 2. Deploy

```bash
kubectl apply -f .
```

### 3. Get External IP

```bash
kubectl get service nginx-loadbalancer -n demo1-loadbalancer -w
```

Wait for `EXTERNAL-IP` to be assigned, then press `Ctrl+C`.

### 4

Wait for `EXTERNAL-IP` to be assigned, then press `Ctrl+C`.

### 3. Access Nginx

```bash
curl http://<EXTERNAL-IP>
```

Replace `<EXTERNAL-IP>` -n demo1-loadbalancer

# Check pods

kubectl get pods -n demo1-loadbalancer -l app=nginx

# Check service

kubectl get service -n demo1-loadbalancer nginx-loadbalancer

# View logs

kubectl logs -n demo1-loadbalancer -l app=nginx

````

## Clean Up

```bash
# Delete all resources
kubectl delete -f . -n demo1-loadbalancer

# Or delete the entire namespace (includes all resources)
kubectl delete namespace demo1-loadbalancer=nginx
````

## Clean Up

```bash
kubectl delete -f .
```

## Notes

- This is the simplest Kubernetes deployment setup
- No persistent storage - data is lost if pods are deleted
- Good for stateless applications like web servers
- Each pod restart starts fresh
