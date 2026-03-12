# Kubernetes

Basic manifests for deploying apt-cacher-ng in a Kubernetes cluster.

## Manifests

| File | Description |
|------|-------------|
| [pod.yaml](../kubernetes/pod.yaml) | Pod with cache volume |
| [service.yaml](../kubernetes/service.yaml) | LoadBalancer service on port 3142 |

## Notes

- For production, replace the `emptyDir` volume with a PersistentVolumeClaim for cache persistence.
- Consider using a StatefulSet if you need stable network identity or persistent storage.
- The service exposes port 3142 — configure your nodes' APT proxy to point to this service IP.
