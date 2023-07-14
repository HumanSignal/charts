# Changelog

## Unreleased

### Improvements

* 

### Fixes
## 1.1.7
### Fixes
* Add USE_NGINX_FOR_EXPORT_DOWNLOADS=0 for `volume` storage.

## 1.1.6
### Fixes
* Add .Values.app.ingress.extraHosts.

## 1.1.5
### Fixes
* Fix indentation for rqworker deploymentStrategy.

## 1.1.4
### Improvements
* Add `.Values.app.nginx.extraEnvironmentVars` and `.Values.app.nginx.extraEnvironmentSecrets`.
* Add `.Values.app.labels`, `.Values.app.podLabels`, `.Values.rqworker.labels`, `.Values.rqworker.podLabels`.
### Fixes
* Fix indentation for pods annotations.

## 1.1.3
### Improvements
* Add `.Values.metrics.*`.

## 1.1.2
### Improvements
* Bump label-studio version to 1.8.0.

## 1.1.1
### Improvements
* Add `.Values.cronjob.jobs.*.successfulJobsHistoryLimit` and `.Values.cronjob.jobs.*.failedJobsHistoryLimit` to override possible parameters.
### Fixes
* Fallback to default `.Values.rqworker.resources.limits` if `.Values.rqworker.queues.*.resources.limits` is not specified
* Fallback to default `.Values.rqworker.resources.requests` if `.Values.rqworker.queues.*.resources.requests` is not specified

## 1.1.0
### Improvements
* Add `.Values.app.terminationGracePeriodSeconds` and `.Values.rqworker.terminationGracePeriodSeconds` to override terminationGracePeriodSeconds for a pod.
* Add `.Values.app.preStopDelaySeconds` to override pre stop delay in seconds.
* Add `.Values.rqworker.queues.*.resources` to override per queue resources requests/limits.

## 1.0.18
### Improvements
* Add `.Values.global.persistence.config.s3.objectParameters` to override possible parameters.

## 1.0.17
### Improvements
* Bump label-studio version to 1.7.3.
* Remove `all` rqworker.
### Fixes
* Allow to set deploymentStrategy in percentage.

## 1.0.16
### Fixes
* Support for different ingress path types `.Values.app.ingress.pathType`.

## 1.0.15
### Fixes
* Remove pattern check from `.Values.cronjob.jobs.*.schedule`.

## 1.0.14
### Improvements
* Add support for CronJobs.

## 1.0.13
### Improvements
* Bump label-studio version to 1.7.2.

## 1.0.12
### Improvements
* Permit the use of slashes in the `.Values.app.ingress.className`

## 1.0.11
### Improvements
* Add LABEL_STUDIO_ prefix to some env variables .

## 1.0.10
### Improvements
* Add `.Values.app.args` and `.Values.app.nginx.args` to override startup arguments.
* Bump label-studio version to 1.7.1.

## 1.0.9
### Improvements
* Add `.Values.customCaCerts` to add certificates into trust store.

## 1.0.8
### Improvements
* Add `.Values.global.cmdWrapper`,`.Values.app.cmdWrapper` or `.Values.rqworker.cmdWrapper` to override command wrapper.

## 1.0.7
### Fixes
* Make `.Values.global.persistence.config.s3.endpointUrl` optional.

## 1.0.6
### Fixes
* Add `.Values.global.persistence.config.s3.endpointUrl` for S3 persistent storage.

## 1.0.5
### Fixes
* Rename `Values.global.contextPath` to `Values.app.contextPath`.
* Check for required variable `LABEL_STUDIO_HOST`.

## 1.0.4
### Features
* Allow to source env variables from a file using `.Values.global.envInjectSources`.

## 1.0.2
### Fixes
* Allow to skip mandatory env variables validation step using `.Values.checkConfig.skipEnvValues`.

## 1.0.1
### Improvements
* Override clusterDomain using `.Values.clusterDomain`.

## 1.0.0
* Initial release.
