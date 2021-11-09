# Label Studio Enterprise Chart 

[Label Studio](https://labelstud.io/) Label Studio is an open source data labeling tool. It lets you label data types like audio, text, images, videos, and time series with a simple and straightforward UI and export to various model formats. It can be used to prepare raw data or improve existing training data to get more accurate ML models.

## Introduction

This chart bootstraps a [Label Studio](https://heartex.com/product) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

This chart has been tested to work with NGINX Ingress, cert-manager.

## Prerequisites software

- Kubernetes 1.17+
- Helm 3.6.3+
- Redis 6.0.5+
- Postgresql 11.9+

## Required k8s secrets

- Docker registry key
```shell
kubectl create secret docker-registry heartex-pull-key \
        --docker-server=https://index.docker.io/v2/ \
        --docker-username=heartexlabs \
        --docker-password=<CUSTOMER_PASSWORD>
```

- License
```shell
# as file
kubectl create secret generic lse-license --from-file=license=path/to/lic
# OR
kubectl create secret generic lse-license --from-literal=license=https://lic.heartex.ai/db/<CUSTOMER_LICENSE_ID>
```

## Configuration (values)

In order to install the chart, you'll need to pass in additional configuration. This configuration comes in the form of Helm values, which are key/value pairs. A minimal install of LSE requires the following values:

```yaml
global:
  imagePullSecrets:
    - name: heartex-pull-key
  enterpriseLicense:
    secretName: "lse-license"
    secretKey: "license"
  pgConfig:
    # PostgreSql instance hostname
    host: "postgresql"
    # PostgreSql database name
    dbName: "my-database"
    # PostgreSql username
    userName: "postgres"
    # PostgreSql password secret coordinates within Kubernetes secrets 
    password:
      secretName: "postgresql"
      secretKey: "postgresql-password"

  redisConfig:
    # Redis connection string
    host: redis://host:port/db
  
# Ingress config for Label Studio
app:
  ingress:
    host: studio.yourdomain.com
# if you have tls cert uncomment next line
#    tls:
#      - secretName: ssl-cert
#        hosts:
#          - studio.yourdomain.com


``` 

Copy these into a new file, which we'll call `lse-values.yaml`. Adjust the included defaults to reflect your environment. For the ful list of configurables, see the [values.yaml](values.yaml)

## Run the installation

Run `helm install` with your values provided:

```console
$ helm install lse . -f lse-values.yaml
```

## Run the upgrade

Run `helm upgrade` with your values provided:

```console
$ helm upgrade lse . -f lse-values.yaml
# OR version upgrade via one line
$ helm upgrade lse . -f lse-values.yaml --set global.image.tag=new_version
```

## Run the uninstall

Run simple `helm delete`:

```console
$ helm delete lse
```