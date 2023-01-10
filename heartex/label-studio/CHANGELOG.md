# Changelog

## Unreleased

### Improvements

* 

### Fixes

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
