# Kubernetes

Basic manifests for deploying apt-cacher-ng in a Kubernetes cluster.

## Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: apt-cacher-ng
  labels:
    app: apt-cacher-ng
spec:
  containers:
    - name: apt-cacher-ng
      image: docker.io/prplanit/apt-cacher-ng-oci:latest
      ports:
        - containerPort: 3142
          protocol: TCP
      volumeMounts:
        - mountPath: /var/cache/apt-cacher-ng
          name: cache
  volumes:
    - name: cache
      emptyDir: {}
```

## Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: apt-cacher-ng
  labels:
    app: apt-cacher-ng
spec:
  type: LoadBalancer
  ports:
    - port: 3142
      targetPort: 3142
      protocol: TCP
  selector:
    app: apt-cacher-ng
```

## Notes

- For production, replace the `emptyDir` volume with a PersistentVolumeClaim for cache persistence.
- Consider using a StatefulSet if you need stable network identity or persistent storage.
- The service exposes port 3142 — configure your nodes' APT proxy to point to this service IP.
