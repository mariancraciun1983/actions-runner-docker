# GitHub Actions Runner Docker

Dockerized version of GitHub Actions Runner with sample kubernetes deployment

## Building

```
docker build \
    --tag mariancraciun/github-actions-runner:latest .
```

## Kubernetes deployment

```
# edit kubernetes/base/secret.yaml files
kubectl apply -k kubernetes
```