# GitHub Actions Runner Docker

Dockerized version of GitHub Actions Runner with sample kubernetes deployment

## Building

```bash
docker build \
    --tag mariancraciun/actions-runner-docker:v1.0 .
```

## Running

The **GITHUB_TOKEN_URL** can be `https://api.github.com/orgs/ORGNAME/actions/runners/registration-token` or `https://api.github.com/repos/ORGNAME/REPONAME/actions/runners/registration-token` depending if you want to register the worker on a per organization or repository.

Similarly **GITHUB_REGISTER_URL** should be either `https://github.com/ORGNAME` or `https://github.com/ORGNAME/REPONAME` .

**GITHUB_WORKER_LABELS** should contain a csv of labels applied to workers.

```bash
docker run -it --rm \
    --hostname testing-github-runner \
    --env GITHUB_TOKEN=ABCDEFGHIJKLMNOPQRST \
    --env GITHUB_TOKEN_URL=https://api.github.com/orgs/ORGNAME/actions/runners/registration-token \
    --env GITHUB_REGISTER_URL=https://github.com/ORGNAME \
    --env GITHUB_WORKER_LABELS=kubernetes,dev
    mariancraciun/github-actions-runner:latest /docker-entrypoint.sh
```

## Kubernetes deployment
In the [./kubernetes](./kubernetes) folder you will find a kustomization file that can be used to deploy a statefulset. I am using a statefulset in order to have consistency among hostnames. However, for most scenarios, a deployment with HPA could be better.

```bash
# edit kubernetes/base/secret.yaml and kubernetes/config.env
kubectl apply -k kubernetes
```