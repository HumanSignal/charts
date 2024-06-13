# Label Studio Helm Chart

[Label Studio](https://labelstud.io/) is an open source data labeling tool. It lets you label data types like audio, text, images, videos, and time series with a simple and straightforward UI and export to various model formats. It can be used to prepare raw data or improve existing training data to get more accurate ML models.

## Introduction

This chart bootstraps a [Label Studio](https://labelstud.io/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

This chart has been tested to work with:

- NGINX Ingress
- cert-manager

## TL;DR

```bash
helm repo add heartex https://charts.heartex.com/
helm repo update

helm install labelstudio heartex/label-studio
```

## Table of contents

- [Prerequisites](#prerequisites)
- [Install](#install)
- [Uninstall](#uninstall)
- [FAQs](#faqs)
- [Label Studio Enterprise](#label-studio-enterprise)
- [Deployment Options](#deployment-options)
  - [Database](#database)
    - [Using the Postgres sub-chart](#using-the-postgres-sub-chart)
  - [Redis](#redis)
    - [Using the redis sub-chart](#using-the-redis-sub-chart)
  - [Example configurations](#example-configurations)
- [Configuration](#configuration)
  - [Label Studio parameters](#label-studio-parameters)
    - [Global parameters](#global-parameters)
    - [Label Studio Service Parameters](#label-studio-parameters)
    - [Rqworker parameters](#rqworker-parameters)
    - [Label Studio Enterprise parameters](#label-studio-enterprise-parameters)
    - [Sub-charts parameters](#sub-charts-parameters)
    - [Other parameters](#other-parameters)
- [Label Studio Enterprise Parameters](#label-studio-enterprise-parameters)
  - [Label Studio Enterprise Overview](#label-studio-enterprise-overview)
  - [Label Studio Enterprise Prerequisites](#label-studio-enterprise-prerequisites)
    - [Label Studio Enterprise License](#label-studio-enterprise-license)
    - [Label Studio Enterprise Docker registry access](#label-studio-enterprise-docker-registry-access)
- [Changelog](https://github.com/heartexlabs/heartex/blob/master/heartex/label-studio/CHANGELOG.md)
- [Seeking help](#seeking-help)

## Prerequisites

- Kubernetes 1.17+
- PV provisioner support in the underlying infrastructure if persistence
  is needed for Label Studio datastore

## Install

To install Label Studio:

```bash
helm repo add heartex https://charts.heartex.com/
helm repo update

helm install labelstudio heartex/label-studio
```

## Uninstall

To uninstall/delete a Helm release `labelstudio`:

```bash
helm delete labelstudio
```

The command removes all the Kubernetes components including data associated with the chart and deletes the release.

## FAQs

Please read the
[FAQs](https://github.com/heartexlabs/heartex/blob/master/heartex/label-studio/FAQs.md)
document.

## Label Studio Enterprise

If using Label Studio Enterprise, several additional steps are necessary before
installing the chart:

- Set `enterprise.enabled` to `true` in `values.yaml` file.
- Set `global.image.repository` to `heartexlabs/label-studio-enterprise` to use a Label Studio Enterprise docker image.
- Set `global.image.tag` to a corresponding version.
- Satisfy the two prerequisites below for
  [Enterprise License](#label-studio-enterprise-license) and
  [Enterprise Docker Registry](#label-studio-enterprise-docker-registry-access).

Once you have these set, it is possible to install Label Studio Enterprise.

Please read through
[Label Studio Enterprise considerations](#Label Studio-enterprise-parameters)
to understand all settings that are enterprise specific.

## Deployment Options

Label Studio is a highly configurable piece of software that can be deployed
in a number of different ways, depending on your use-case.

All combinations of various runtimes, databases and configuration methods are
supported by this Helm chart.
The recommended approach is to use the Ingress Controller based configuration
along-with DB-less mode.

Following sections detail on various high-level architecture options available:

### Database

Label Studio can run with an external database. By default, this chart installs Label Studio with [PostgreSQL packaged by Bitnami](https://bitnami.com/stack/postgresql/helm).

You can override the database using `global.pgConfig` section. For more details, please read the [Global parameters](#global-parameters) section.

#### Using the Postgres sub-chart

The chart spawn a Postgres instance using [Bitnami's Postgres
chart](https://github.com/bitnami/heartex/blob/master/bitnami/postgresql/README.md)
as a sub-chart. Set `postgresql.enabled=false` to disable the sub-chart.

The Postgres sub-chart is best used to quickly provision temporary environments
without installing and configuring your database separately. For longer-lived
environments, we recommend you manage your database outside the Label Studio Helm
release.

### Redis

Label Studio Enterprise can run with an external Redis. This chart optionally installs Label Studio Enterprise with [Bitnami's Redis chart](https://bitnami.com/stack/redis/helm)

You can override the Redis using `global.redisConfig` section. For more details, please read the [Global parameters](#global-parameters) section.

#### Using the Redis sub-chart

The chart spawn a Redis instance using [Bitnami's Redis
chart](https://github.com/bitnami/heartex/blob/master/bitnami/redis/README.md)
as a sub-chart. Set `redis.enabled=false` to disable the sub-chart.

The Redis sub-chart is best used to quickly provision temporary environments
without installing and configuring Redis separately. For longer-lived
environments, we recommend you manage your Redis outside the Label Studio Helm
release.

### Example configurations

Several example `values.yaml` are available in the
[example-values](https://github.com/heartexlabs/charts/tree/master/heartex/label-studio/example-values)
directory.

## Configuration

### Global parameters

| Parameter                                                                   | Description                                                                                                                         | Default                    |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|----------------------------|
| `global.imagePullSecrets`                                                   | Global Docker registry secret names as an array                                                                                     | `[]`                       |
| `global.image.repository`                                                   | Image repository                                                                                                                    | `heartexlabs/label-studio` |
| `global.image.pullPolicy`                                                   | Image pull policy                                                                                                                   | `IfNotPresent`             |
| `global.image.tag`                                                          | Image tag (immutable tags are recommended)                                                                                          | `develop`                  |
| `global.pgConfig.host`                                                      | PostgreSQL hostname                                                                                                                 | `""`                       |
| `global.pgConfig.port`                                                      | PostgreSQL port                                                                                                                     | `5432`                     |
| `global.pgConfig.dbName`                                                    | PostgreSQL database name                                                                                                            | `""`                       |
| `global.pgConfig.userName`                                                  | PostgreSQL database user account                                                                                                    | `""`                       |
| `global.pgConfig.password.secretName`                                       | Name of an existing secret holding the password of PostgreSQL database user account                                                 | `""`                       |
| `global.pgConfig.password.secretKey`                                        | Key of an existing secret holding the password of PostgreSQL database user account                                                  | `""`                       |
| `global.pgConfig.ssl.pgSslMode`                                             | [PostgreSQL SSL mode](https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNECT-SSLMODE)                             | `""`                       |
| `global.pgConfig.ssl.pgSslSecretName`                                       | Name of an existing secret holding the ssl certificate for PostgreSQL host                                                          | `""`                       |
| `global.pgConfig.ssl.pgSslRootCertSecretKey`                                | Key of an existing secret holding the ssl certificate for PostgreSQL host                                                           | `""`                       |
| `global.pgConfig.ssl.pgSslCertSecretKey`                                    | Name of an existing secret holding the ssl certificate private key for PostgreSQL host                                              | `""`                       |
| `global.pgConfig.ssl.pgSslKeySecretKey`                                     | Key of an existing secret holding the ssl certificate private key for PostgreSQL host                                               | `""`                       |
| `global.redisConfig.host`                                                   | Redis connection string in a format: redis://[:password]@localhost:6379/1                                                           | `""`                       |
| `global.redisConfig.password.secretName`                                    | Name of an existing secret holding the password of Redis database                                                                   | `""`                       |
| `global.redisConfig.password.secretKey`                                     | Key of an existing secret holding the password of Redis database                                                                    | `""`                       |
| `global.redisConfig.ssl.redisSslCertReqs`                                   | Whether to validate the server public key or ignore it. Accepts (`""`, `"optional"`, `"required"`).                                 | `""`                       |
| `global.redisConfig.ssl.redisSslSecretName`                                 | Name of an existing secret holding the ssl certificate for Redis host                                                               | `""`                       |
| `global.redisConfig.ssl.redisSslCaCertsSecretKey`                           | Key of an existing secret holding the ssl certificate for Redis host                                                                | `""`                       |
| `global.redisConfig.ssl.redisSslCertFileSecretKey`                          | Name of an existing secret holding the ssl certificate private key for Redis host                                                   | `""`                       |
| `global.redisConfig.ssl.redisSslKeyFileSecretKey`                           | Key of an existing secret holding the ssl certificate private key for Redis host                                                    | `""`                       |
| `global.extraEnvironmentVars`                                               | Key/value map of an extra Environment variables, for example, `PYTHONUNBUFFERED: 1`                                                 | `{}`                       |
| `global.extraEnvironmentSecrets`                                            | Key/value map of an extra Secrets                                                                                                   | `{}`                       |
| `global.persistence.enabled`                                                | Enable persistent storage. [See more about setting up persistent storage](https://labelstud.io/guide/persistent_storage.html)       | `true`                     |
| `global.persistence.type`                                                   | Persistent storage type                                                                                                             | `volume`                   |
| `global.persistence.config.s3.accessKey`                                    | Access key to use to access AWS S3                                                                                                  | `""`                       |
| `global.persistence.config.s3.secretKey`                                    | Secret key to use to access AWS S3                                                                                                  | `""`                       |
| `global.persistence.config.s3.accessKeyExistingSecret`                      | Existing Secret name to extract Access key from to access AWS S3                                                                    | `""`                       |
| `global.persistence.config.s3.accessKeyExistingSecretKey`                   | Existing Secret key to extract Access key from to access AWS S3                                                                     | `""`                       |
| `global.persistence.config.s3.secretKeyExistingSecret`                      | Existing Secret name to extract Access secret key from to access AWS S3                                                             | `""`                       |
| `global.persistence.config.s3.secretKeyExistingSecretKey`                   | Existing Secret key to extract Access secret key from to access AWS S3                                                              | `""`                       |
| `global.persistence.config.s3.region`                                       | AWS S3 region                                                                                                                       | `""`                       |
| `global.persistence.config.s3.bucket`                                       | AWS S3 bucket name                                                                                                                  | `""`                       |
| `global.persistence.config.s3.folder`                                       | AWS S3 folder name                                                                                                                  | `""`                       |
| `global.persistence.config.s3.urlExpirationSecs`                            | The number of seconds that a presigned URL is valid for                                                                             | `86400`                    |
| `global.persistence.config.s3.endpointUrl`                                  | Custom S3 URL to use when connecting to S3, including scheme                                                                        | `""`                       |
| `global.persistence.config.s3.objectParameters`                             | Use this to set parameters on all objects.                                                                                          | `{}`                       |
| `global.persistence.config.volume.storageClass`                             | StorageClass for Persistent Volume                                                                                                  | `""`                       |
| `global.persistence.config.volume.size`                                     | Persistent volume size                                                                                                              | `10Gi`                     |
| `global.persistence.config.volume.accessModes`                              | PVC Access mode                                                                                                                     | `[ReadWriteOnce]`          |
| `global.persistence.config.volume.annotations`                              | Persistent volume additional annotations                                                                                            | `{}`                       |
| `global.persistence.config.volume.existingClaim`                            | Name of an existing PVC to use                                                                                                      | `""`                       |
| `global.persistence.config.volume.resourcePolicy`                           | PVC resource policy                                                                                                                 | `""`                       |
| `global.persistence.config.volume.annotations`                              | Persistent volume additional annotations                                                                                            | `{}`                       |
| `global.persistence.config.azure.storageAccountName`                        | Azure Storage Account Name to use to access Azure Blob Storage                                                                      | `""`                       |
| `global.persistence.config.azure.storageAccountKey`                         | Azure Storage Account Key to use to access Azure Blob Storage                                                                       | `""`                       |
| `global.persistence.config.azure.storageAccountNameExistingSecret`          | Existing Secret name to extract Azure Storage Account Name from to access Azure Blob Storage                                        | `""`                       |
| `global.persistence.config.azure.storageAccountNameExistingSecretKey`       | Existing Secret key to extract Azure Storage Account Name from to use to access Azure Blob Storage                                  | `""`                       |
| `global.persistence.config.azure.storageAccountKeyExistingSecret`           | Existing Secret name to extract Azure Storage Account Key from to access Azure Blob Storage                                         | `""`                       |
| `global.persistence.config.azure.storageAccountKeyExistingSecretKey`        | Existing Secret key to extract Azure Storage Account Key from to use to access Azure Blob Storage                                   | `""`                       |
| `global.persistence.config.azure.containerName`                             | Azure Storage container name                                                                                                        | `""`                       |
| `global.persistence.config.azure.folder`                                    | Azure Storage folder name                                                                                                           | `""`                       |
| `global.persistence.config.azure.urlExpirationSecs`                         | The number of seconds that a presigned URL is valid for                                                                             | `86400`                    |
| `global.persistence.config.gcs.projectID`                                   | GCP Project ID to use                                                                                                               | `""`                       |
| `global.persistence.config.gcs.applicationCredentialsJSON`                  | Service Account key to access GCS                                                                                                   | `""`                       |
| `global.persistence.config.gcs.applicationCredentialsJSONExistingSecret`    | Existing Secret name to extract Service Account Key from to access GCS                                                              | `""`                       |
| `global.persistence.config.gcs.applicationCredentialsJSONExistingSecretKey` | Existing Secret key to extract Service Account Key from to access GCS                                                               | `""`                       |
| `global.persistence.config.gcs.bucket`                                      | GCS bucket name                                                                                                                     | `""`                       |
| `global.persistence.config.gcs.folder`                                      | GCS folder name                                                                                                                     | `""`                       |
| `global.persistence.config.gcs.urlExpirationSecs`                           | The number of seconds that a presigned URL is valid for                                                                             | `86400`                    |
| `global.featureFlags`                                                       | Key/value map of Feature Flags                                                                                                      | `{}`                       |
| `global.envInjectSources`                                                   | List of file names of a shell scripts to load additional environment variables from. This is useful when using Vault Agent Injector | `[]`                       |
| `global.cmdWrapper`                                                         | Additional commands to run prior to starting App. Useful to run wrappers before startup command                                     | `""`                       |
| `global.customCaCerts`                                                      | List of file names of SSL certificates to add into trust chain                                                                      | `[]`                       |

### Label Studio parameters

| Parameter                                      | Description                                                                                                          | Default                  |
|------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|--------------------------|
| `app.args`                                     | Override default container args (useful when using custom images)                                                    | `["label-studio-uwsgi"]` |
| `app.deploymentStrategy.type`                  | Deployment strategy type                                                                                             | `RollingUpdate`          |
| `app.deploymentAnnotations`                    | Deployment annotations                                                                                               | `{}`                     |
| `app.replicas`                                 | Amount of app pod replicas                                                                                           | `1`                      |
| `app.NameOverride`                             | String to partially override release template name                                                                   | `""`                     |
| `app.FullnameOverride`                         | String to fully override release template name                                                                       | `""`                     |
| `app.resources.requests.memory`                | The requested memory resources for the App container                                                                 | `384Mi`                  |
| `app.resources.requests.cpu`                   | The requested cpu resources for the App container                                                                    | `250m`                   |
| `app.resources.limits.memory`                  | The memory resources limits for the App container                                                                    | `""`                     |
| `app.resources.limits.cpu`                     | The cpu resources limits for the App container                                                                       | `""`                     |
| `app.initContainer.resources.requests`         | Init container db-migrations resource requests                                                                       | `{}`                     |
| `app.initContainer.resources.limits`           | Init container db-migrations resource limits                                                                         | `{}`                     |
| `app.readinessProbe.enabled`                   | Enable redinessProbe                                                                                                 | `false`                  |
| `app.readinessProbe.path`                      | Path for reasinessProbe                                                                                              | `/version`               |
| `app.readinessProbe.failureThreshold`          | When a probe fails, Kubernetes will try failureThreshold times before giving up                                      | `2`                      |
| `app.readinessProbe.initialDelaySeconds`       | Number of seconds after the container has started before probe initiates                                             | `60`                     |
| `app.readinessProbe.periodSeconds`             | How often (in seconds) to perform the probe                                                                          | `10`                     |
| `app.readinessProbe.successThreshold`          | Minimum consecutive successes for the probe to be considered successful after having failed                          | `1`                      |
| `app.readinessProbe.timeoutSeconds`            | Number of seconds after which the probe times out                                                                    | `5`                      |
| `app.livenessProbe.enabled`                    | Enable livenessProbe                                                                                                 | `true`                   |
| `app.livenessProbe.path`                       | Path for livenessProbe                                                                                               | `/health`                |
| `app.livenessProbe.failureThreshold`           | When a probe fails, Kubernetes will try failureThreshold times before giving up                                      | `3`                      |
| `app.livenessProbe.initialDelaySeconds`        | Number of seconds after the container has started before probe initiates                                             | `60`                     |
| `app.livenessProbe.periodSeconds`              | How often (in seconds) to perform the probe                                                                          | `10`                     |
| `app.livenessProbe.successThreshold`           | Minimum consecutive successes for the probe to be considered successful after having failed                          | `1`                      |
| `app.livenessProbe.timeoutSeconds`             | Number of seconds after which the probe times out                                                                    | `5`                      |
| `app.extraEnvironmentVars`                     | A map of extra environment variables to set                                                                          | `{}`                     |
| `app.extraEnvironmentSecrets`                  | A map of extra environment secrets to set                                                                            | `{}`                     |
| `app.nodeSelector`                             | Labels for pod assignment, formatted as a multi-line string or YAML map                                              | `{}`                     |
| `app.annotations`                              | k8s annotations to attach to the app pods                                                                            | `{}`                     |
| `app.extraLabels`                              | extra k8s labels to attach                                                                                           | `{}`                     |
| `app.affinity`                                 | Affinity for pod assignment                                                                                          | `{}`                     |
| `app.tolerations`                              | Toleration settings for pod                                                                                          | `[]`                     |
| `app.nginx.extraEnvironmentVars`               | A map of extra environment variables to set for nginx container                                                      | `{}`                     |
| `app.nginx.extraEnvironmentSecrets`            | A map of extra environment secrets to set for nginx container                                                        | `{}`                     |
| `app.nginx.resources.requests`                 | Nginx sidecar container: resource requests                                                                           | `{}`                     |
| `app.nginx.resources.limits`                   | Nginx sidecar container: resource limits                                                                             | `{}`                     |
| `app.dnsPolicy`                                | Pod DNS policy                                                                                                       | `ClusterFirst`           |
| `app.enableServiceLinks`                       | Service environment variables                                                                                        | `false`                  |
| `app.shareProcessNamespace`                    | Enable shared process namespace in a pod                                                                             | `false`                  |
| `app.automountServiceAccountToken`             | Automount service account token for the server service account                                                       | `true`                   |
| `app.serviceAccount.create`                    | Enable the creation of a ServiceAccount for app pod                                                                  | `true`                   |
| `app.serviceAccount.name`                      | Name of the created ServiceAccount                                                                                   |                          |
| `app.serviceAccount.annotations`               | Custom annotations for app ServiceAccount                                                                            | `{}`                     |
| `app.podSecurityContext.enabled`               | Enable pod Security Context                                                                                          | `true`                   |
| `app.podSecurityContext.fsGroup`               | Group ID for the pod                                                                                                 | `1001`                   |
| `app.containerSecurityContext.enabled`         | Enable container security context                                                                                    | `true`                   |
| `app.containerSecurityContext.runAsUser`       | User ID for the container                                                                                            | `1001`                   |
| `app.containerSecurityContext.runAsNonRoot`    | Avoid privelege escalation to root user                                                                              | `true`                   |
| `app.extraVolumes`                             | Array to add extra volumes                                                                                           | `[]`                     |
| `app.extraVolumeMounts`                        | Array to add extra mounts (normally used with extraVolumes)                                                          | `[]`                     |
| `app.topologySpreadConstraints`                | Topology Spread Constraints for pod assignment                                                                       | `[]`                     |
| `app.terminationGracePeriodSeconds`            | Termination grace period in seconds                                                                                  | `30`                     |
| `app.preStopDelaySeconds`                      | PreStop delay in seconds                                                                                             | `15`                     |
| `app.topologySpreadConstraints`                | Topology Spread Constraints for pod assignment                                                                       | `[]`                     |
| `app.nginx.args`                               | Override default container args (useful when using custom images)                                                    | `["nginx"]`              |
| `app.nginx.livenessProbe.enabled`              | Nginx sidecar container: Enable livenessProbe                                                                        | `true`                   |
| `app.nginx.livenessProbe.path`                 | Nginx sidecar container: path for livenessProbe                                                                      | `/nginx_health`          |
| `app.nginx.livenessProbe.failureThreshold`     | Nginx sidecar container: when a probe fails, Kubernetes will try failureThreshold times before giving up             | `2`                      |
| `app.nginx.livenessProbe.initialDelaySeconds`  | Nginx sidecar container: Number of seconds after the container has started before probe initiates                    | `60`                     |
| `app.nginx.livenessProbe.periodSeconds`        | Nginx sidecar container: How often (in seconds) to perform the probe                                                 | `5`                      |
| `app.nginx.livenessProbe.successThreshold`     | Nginx sidecar container: Minimum consecutive successes for the probe to be considered successful after having failed | `1`                      |
| `app.nginx.livenessProbe.timeoutSeconds`       | Nginx sidecar container: Number of seconds after which the probe times out                                           | `3`                      |
| `app.nginx.readinessProbe.enabled`             | Nginx sidecar container: Enable redinessProbe                                                                        | `true`                   |
| `app.nginx.readinessProbe.path`                | Nginx sidecar container: Path for reasinessProbe                                                                     | `/version`               |
| `app.nginx.readinessProbe.failureThreshold`    | Nginx sidecar container: When a probe fails, Kubernetes will try failureThreshold times before giving up             | `2`                      |
| `app.nginx.readinessProbe.initialDelaySeconds` | Nginx sidecar container: Number of seconds after the container has started before probe initiates                    | `60`                     |
| `app.nginx.readinessProbe.periodSeconds`       | Nginx sidecar container: How often (in seconds) to perform the probe                                                 | `10`                     |
| `app.nginx.readinessProbe.successThreshold`    | Nginx sidecar container: Minimum consecutive successes for the probe to be considered successful after having failed | `1`                      |
| `app.nginx.readinessProbe.timeoutSeconds`      | Nginx sidecar container: Number of seconds after which the probe times out                                           | `5`                      |
| `app.service.type`                             | k8s service type                                                                                                     | `ClusterIP`              |
| `app.service.port`                             | k8s service port                                                                                                     | `80`                     |
| `app.service.targetPort`                       | k8s service target port                                                                                              | `8085`                   |
| `app.service.portName`                         | k8s service port name                                                                                                | `service`                |
| `app.service.annotations`                      | Custom annotations for app service                                                                                   | `{}`                     |
| `app.service.sessionAffinity`                  | Custom annotations for app service                                                                                   | `None`                   |
| `app.service.sessionAffinityConfig`            | Additional settings for the sessionAffinity                                                                          | `{}`                     |
| `app.ingress.enabled`                          | Set to true to enable ingress record generation                                                                      | `false`                  |
| `app.ingress.className`                        | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                        | `""`                     |
| `app.ingress.host`                             | Default host for the ingress resource                                                                                | `""`                     |
| `app.ingress.path`                             | The Path to LabelStudio. You may need to set this to '/*' in order to use this with ALB ingress controllers.         | `/`                      |
| `app.ingress.extraPaths`                       | Extra paths to prepend to the host configuration                                                                     | `[]`                     |
| `app.ingress.extraHosts`                       | Extra hosts to prepend to the hosts configuration                                                                    | `[]`                     |
| `app.ingress.tls`                              | TLS secrets definition                                                                                               | `[]`                     |
| `app.ingress.annotations`                      | Additional ingress annotations                                                                                       | `{}`                     |
| `app.ingress.pathType`                         | Ingress path type                                                                                                    | `ImplementationSpecific` |
| `app.rbac.create`                              | Specifies whether RBAC resources should be created for app service                                                   | `false`                  |
| `app.rbac.rules`                               | Custom RBAC rules to set for app service                                                                             | `[]`                     |
| `app.contextPath`                              | Context path appended for health/readiness checks                                                                    | `/`                      |
| `app.cmdWrapper`                               | Additional commands to run prior to starting App. Useful to run wrappers before startup command                      | `""`                     |
| `app.initContainers`                           | Additional init containers to the App Deployment pod                                                                 | `[]`                     |

### Rqworker parameters

Supported only in LabelStudio Enterprise

| Parameter                                        | Description                                                                                     | Default                                |
|--------------------------------------------------|-------------------------------------------------------------------------------------------------|----------------------------------------|
| `rqworker.enabled`                               | Enable rqworker pod                                                                             | `true`                                 |
| `rqworker.NameOverride`                          | String to partially override release template name                                              | `""`                                   |
| `rqworker.FullnameOverride`                      | String to fully override release template name                                                  | `""`                                   |
| `rqworker.deploymentStrategy.type`               | Deployment strategy type                                                                        | `Recreate`                             |
| `rqworker.extraEnvironmentVars`                  | A map of extra environment variables to set                                                     | `{}`                                   |
| `rqworker.extraEnvironmentSecrets`               | A map of extra environment secrets to set                                                       | `{}`                                   |
| `rqworker.nodeSelector`                          | labels for pod assignment, formatted as a multi-line string or YAML map                         | `{}`                                   |
| `rqworker.annotations`                           | k8s annotations to attach to the rqworker pods                                                  | `{}`                                   |
| `rqworker.extraLabels`                           | extra k8s labels to attach                                                                      | `{}`                                   |
| `rqworker.affinity`                              | Affinity for pod assignment                                                                     | `{}`                                   |
| `rqworker.tolerations`                           | Toleration settings for pod                                                                     | `[]`                                   |
| `rqworker.queues.high.replicas`                  | Rqworker queue "high" replicas amount                                                           | `1`                                    |
| `rqworker.queues.high.args`                      | Rqworker queue "high" launch arguments                                                          | `"high"`                               |
| `rqworker.queues.high.resources`                 | Rqworker queue "high" resources                                                                 | `{}`                                   |
| `rqworker.queues.low.replicas`                   | Rqworker queue "low" replicas amount                                                            | `1`                                    |
| `rqworker.queues.low.args`                       | Rqworker queue "low" launch arguments                                                           | `"low"`                                |
| `rqworker.queues.low.resources`                  | Rqworker queue "low" resources                                                                  | `{}`                                   |
| `rqworker.queues.default.replicas`               | Rqworker queue "default" replicas amount                                                        | `1`                                    |
| `rqworker.queues.default.args`                   | Rqworker queue "default" launch arguments                                                       | `"default"`                            |
| `rqworker.queues.default.resources`              | Rqworker queue "default" resources                                                              | `{}`                                   |
| `rqworker.queues.critical.replicas`              | Rqworker queue "critical" replicas amount                                                       | `1`                                    |
| `rqworker.queues.critical.args`                  | Rqworker queue "critical" launch arguments                                                      | `"critical"`                           |
| `rqworker.queues.critical.resources`             | Rqworker queue "critical" resources                                                             | `{}`                                   |
| `rqworker.dnsPolicy`                             | Pod DNS policy                                                                                  | `ClusterFirst`                         |
| `rqworker.enableServiceLinks`                    | Service environment variables                                                                   | `false`                                |
| `rqworker.shareProcessNamespace`                 | Enable shared process namespace in a pod                                                        | `false`                                |
| `rqworker.automountServiceAccountToken`          | Automount service account token for the server service account                                  | `true`                                 |
| `rqworker.readinessProbe.enabled`                | Enable redinessProbe                                                                            | `false`                                |
| `rqworker.readinessProbe.path`                   | Path for reasinessProbe                                                                         | `/version`                             |
| `rqworker.readinessProbe.failureThreshold`       | When a probe fails, Kubernetes will try failureThreshold times before giving up                 | `2`                                    |
| `rqworker.readinessProbe.initialDelaySeconds`    | Number of seconds after the container has started before probe initiates                        | `60`                                   |
| `rqworker.readinessProbe.periodSeconds`          | How often (in seconds) to perform the probe                                                     | `5`                                    |
| `rqworker.readinessProbe.successThreshold`       | Minimum consecutive successes for the probe to be considered successful after having failed     | `1`                                    |
| `rqworker.readinessProbe.timeoutSeconds`         | Number of seconds after which the probe times out                                               | `3`                                    |
| `rqworker.livenessProbe.enabled`                 | Enable livenessProbe                                                                            | `false`                                |
| `rqworker.livenessProbe.path`                    | Path for livenessProbe                                                                          | `/health`                              |
| `rqworker.livenessProbe.failureThreshold`        | When a probe fails, Kubernetes will try failureThreshold times before giving up                 | `2`                                    |
| `rqworker.livenessProbe.initialDelaySeconds`     | Number of seconds after the container has started before probe initiates                        | `60`                                   |
| `rqworker.livenessProbe.periodSeconds`           | How often (in seconds) to perform the probe                                                     | `5`                                    |
| `rqworker.livenessProbe.successThreshold`        | Minimum consecutive successes for the probe to be considered successful after having failed     | `1`                                    |
| `rqworker.livenessProbe.timeoutSeconds`          | Number of seconds after which the probe times out                                               | `3`                                    |
| `rqworker.serviceAccount.create`                 | Enable the creation of a ServiceAccount for rqworker pod                                        | `true`                                 |
| `rqworker.serviceAccount.name`                   | Name of the created ServiceAccount                                                              | `""`                                   |
| `rqworker.podSecurityContext.enabled`            | Enable pod Security Context                                                                     | `true`                                 |
| `rqworker.podSecurityContext.fsGroup`            | Group ID for the pod                                                                            | `1001`                                 |
| `rqworker.containerSecurityContext.enabled`      | Enable container security context                                                               | `true`                                 |
| `rqworker.containerSecurityContext.runAsUser`    | User ID for the container                                                                       | `1001`                                 |
| `rqworker.containerSecurityContext.runAsNonRoot` | Avoid privelege escalation to root user                                                         | `true`                                 |
| `rqworker.serviceAccount.annotations`            | Custom annotations for app ServiceAccount                                                       | `{}`                                   |
| `rqworker.extraVolumes`                          | Array to add extra volumes                                                                      | `[]`                                   |
| `rqworker.extraVolumeMounts`                     | Array to add extra mounts (normally used with extraVolumes)                                     | `[]`                                   |
| `rqworker.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment                                                  | `[]`                                   |
| `rqworker.rbac.create`                           | Specifies whether RBAC resources should be created for rqworker service                         | `false`                                |
| `rqworker.rbac.rules`                            | Custom RBAC rules to set for rqworker service                                                   | `[]`                                   |
| `rqworker.cmdWrapper`                            | Additional commands to run prior to starting App. Useful to run wrappers before startup command | `""`                                   |

### Label Studio Enterprise parameters

| Parameter                                 | Description                                                                        | Default   |
|-------------------------------------------|------------------------------------------------------------------------------------|-----------|
| `enterprise.enabled`                      | Enable Enterprise features                                                         | `false`   |
| `enterprise.enterpriseLicense.secretName` | Name of an existing secret holding the Label Studio Enterprise license information | `""`      |
| `enterprise.enterpriseLicense.secretKey`  | Key of an existing secret holding the enterprise license information               | `license` |

### Sub-charts parameters

| Parameter                  | Description                                                                                             | Default       |
|----------------------------|---------------------------------------------------------------------------------------------------------|---------------|
| `postgresql.enabled`       | Enable Postgresql sub-chart                                                                             | `true`        |
| `postgresql.architecture`  | PostgreSQL architecture (standalone or replication)                                                     | `standalone`  |
| `postgresql.image.tag`     | PostgreSQL image tag                                                                                    | `13.8.0`      |
| `postgresql.auth.username` | Name for a custom user to create                                                                        | `labelstudio` |
| `postgresql.auth.password` | Password for the custom user to create. Ignored if `auth.existingSecret` with key password is provided  | `labelstudio` |
| `postgresql.auth.database` | Name for a custom database to create                                                                    | `labelstudio` |
| `redis.enabled`            | Enable Redis sub-chart                                                                                  | `false`       |
| `redis.architecture`       | Redis architecture. Allowed values: `standalone` or `replication`                                       | `standalone`  |
| `redis.auth.enabled`       | Enable password authentication                                                                          | `false`       |

### Cronjob parameters

| Parameter                                | Description                                                         | Default |
|------------------------------------------|---------------------------------------------------------------------|---------|
| `cronjob.enabled`                        | Enable cronjobs                                                     | `false` |
| `cronjob.jobs`                           | A map of predefined cronjobs                                        | `{}`    |
| `cronjob.jobs.*.schedule`                | Cronjob schedule according to cron format                           | `""`    |
| `cronjob.jobs.*.args`                    | Cronjob launch arguments                                            | `""`    |
| `cronjob.jobs.*.extraEnvironmentVars`    | Cronjob key/value map of an extra Environment variables             | `{}`    |
| `cronjob.jobs.*.extraEnvironmentSecrets` | Cronjob key/value map of an extra Secrets                           | `{}`    |
| `cronjob.jobs.*.extraVolumes`            | Cronjob array to add extra volumes                                  | `[]`    |
| `cronjob.jobs.*.extraVolumeMounts`       | Cronjob array to add extra mounts (normally used with extraVolumes) | `[]`    |
| `cronjob.jobs.*.restartPolicy`           | Cronjob restart policy: OnFailure or Never                          | `[]`    |
| `cronjob.jobs.*.backoffLimit`            | The number of retries before considering a Job as failed            | `""`    |
| `cronjob.jobs.*.concurrencyPolicy`       | Concurrency policy                                                  | `""`    |

### metrics parameters

| Parameter                                | Description                                                         | Default |
|------------------------------------------|---------------------------------------------------------------------|---------|
| `metrics.enabled`                        | Enable metrics                                                      | `true`  |
| `metrics.uwsgiExporter`                  | Configuration map for uwsgiExporter                                 | `{}`    |

### Other parameters

| Parameter                   | Description                                      | Default         |
|-----------------------------|--------------------------------------------------|-----------------|
| `upgradeCheck.enabled`      | Enable upgradecheck                              | `false`         |
| `ci`                        | Indicate that deployment running for CI purposes | `false`         |
| `clusterDomain`             | Kubernetes Cluster Domain                        | `cluster.local` |
| `checkConfig.skipEnvValues` | Skip validation for env variables                | `false`         |

#### The `global.extraEnvironmentVars` usage

The `global.extraEnvironmentVars` section can be used to configure environment properties of Label Studio.
Any key value put under this section translates to environment variables
used to control Label Studio's configuration. Every key is upper-cased before setting the environment variable.
An example:

```yaml
global:
  extraEnvironmentVars:
     PG_USER: labelstudio
```

#### The `global.featureFlags` usage

The `global.featureFlags` section can be used to set feature flags of Label Studio.
Any key value put under this section translates to environment variables
used to control Label Studio's feature flags configuration. Every key should start from `ff_` or `fflag_` in lower case.
An example:

```yaml
global:
  featureFlags:
    fflag_enable_some_cool_feature_short: true
```

## Label Studio Enterprise Parameters

### Label Studio Enterprise Overview

Label Studio Enterprise requires some additional configuration not needed when using
Label Studio Open-Source. To use Label Studio Enterprise, at the minimum,
you need to do the following:

- Set `enterprise.enabled` to `true` in `values.yaml` file.
- Update values.yaml to use a Label Studio Enterprise image.
- Satisfy the two prerequisites below for Enterprise License and
  Enterprise Docker Registry.

Once you have these set, it is possible to install Label Studio Enterprise,
but please make sure to review the below sections for other settings that
you should consider configuring before installing Label Studio Enterprise.

### Label Studio Enterprise Prerequisites

For long-lived or Production ready environments we strongly recommend to use separate instance of PostgreSQL and Redis.

#### Label Studio Enterprise License

Label Studio Enterprise 2.1+ can run with a static license file or by obtaining a license key from a License Server.

If you have paid for a license, but you do not have a copy of yours, please
contact Label Studio Support. Once you have it, you will need to store it in a Secret:

```shell
# as file
kubectl create secret generic lse-license --from-file=license=path/to/lic
# OR
kubectl create secret generic lse-license --from-literal=license=https://<LICENSE_SERVER>/<CUSTOMER_LICENSE_ID>
```

You can override the secret name in `values.yaml`, in the `enterprise.enterpriseLicense` key.
Please ensure the above secret is created in the same namespace in which Label Studio Enterprise is going to be deployed.

#### Label Studio Enterprise Docker registry access

Label Studio Enterprise uses a private Docker registry and require a pull secret.

You should have received credentials to log into Docker Hub after
purchasing Label Studio Enterprise. Use provided credentials to create registry
secrets:

```bash
kubectl create secret docker-registry heartex-pull-key \
        --docker-server=https://index.docker.io/v2/ \
        --docker-username=heartexlabs \
        --docker-password=<CUSTOMER_PASSWORD>
```

You can override the secret names in `values.yaml` in the `global.imagePullSecrets` section.
Please ensure the above secret is created in the same namespace in which Label Studio Enterprise is going to be deployed.

## Seeking help

If you run into an issue, bug or have a question, please reach out to the Label Studio
community via [Label Studio Slack Community](https://slack.labelstud.io/).
