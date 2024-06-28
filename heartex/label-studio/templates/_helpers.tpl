{{/*
Expand the name
*/}}
{{- define "ls-app.name" -}}
{{- default "ls-app" .Values.app.NameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "ls-rqworker.name" -}}
{{- default "ls-rqworker" .Values.rqworker.NameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "ls-pvc.name" -}}
{{- "ls-pvc" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "ls-secrets.name" -}}
{{- "ls-secrets" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return the PVC name (only in standalone mode)
*/}}
{{- define "ls-pvc.claimName" -}}
{{- if and .Values.global.persistence.config.volume.existingClaim }}
    {{- printf "%s" (tpl .Values.global.persistence.config.volume.existingClaim $) -}}
{{- else -}}
    {{- printf "%s" (include "ls-pvc.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ls-app.fullname" -}}
{{- if .Values.app.FullnameOverride }}
{{- .Values.app.FullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "ls-app" .Values.app.FullnameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "ls-cronjob.fullname" -}}
{{- if .Values.cronjob.FullnameOverride }}
{{- .Values.cronjob.FullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "ls-cronjob" .Values.cronjob.FullnameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "ls-rqworker.fullname" -}}
{{- if .Values.rqworker.FullnameOverride }}
{{- .Values.rqworker.FullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "ls-rqworker" .Values.rqworker.FullnameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "ls-pvc.fullname" -}}
{{- $name := "ls-pvc" }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "ls-secrets.fullname" -}}
{{- $name := "ls-secrets" }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ls.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels for ls-app
*/}}
{{- define "ls-app.labels" -}}
helm.sh/chart: {{ include "ls.chart" . }}
{{ include "ls-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for ls-app
*/}}
{{- define "ls-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ls-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels for ls-pvc
*/}}
{{- define "ls-pvc.labels" -}}
helm.sh/chart: {{ include "ls.chart" . }}
{{ include "ls-pvc.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for ls-pvc
*/}}
{{- define "ls-pvc.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ls-pvc.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels for ls-pvc
*/}}
{{- define "ls-secrets.labels" -}}
helm.sh/chart: {{ include "ls.chart" . }}
{{ include "ls-secrets.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for ls-pvc
*/}}
{{- define "ls-secrets.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ls-secrets.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels for ls-rqworker
*/}}
{{- define "ls-rqworker.labels" -}}
helm.sh/chart: {{ include "ls.chart" . }}
{{ include "ls-rqworker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for ls-rqworker
*/}}
{{- define "ls-rqworker.selectorLabels" -}}
app.kubernetes.io/part-of: label-studio
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels for ls-cronjob
*/}}
{{- define "ls-cronjob.labels" -}}
helm.sh/chart: {{ include "ls.chart" . }}
{{ include "ls-cronjob.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for ls-cronjob
*/}}
{{- define "ls-cronjob.selectorLabels" -}}
app.kubernetes.io/part-of: label-studio
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the app service account to use
*/}}
{{- define "ls-app.serviceAccountName" -}}
{{- if .Values.app.serviceAccount.create }}
{{- default (include "ls-app.fullname" .) .Values.app.serviceAccount.name }}
{{- else }}
{{- default "ls" .Values.app.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the rqworker service account to use
*/}}
{{- define "ls-rqworker.serviceAccountName" -}}
{{- if .Values.rqworker.serviceAccount.create }}
{{- default (include "ls-rqworker.fullname" .) .Values.rqworker.serviceAccount.name }}
{{- else }}
{{- default "rqworker" .Values.rqworker.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "tplvalues.render" -}}
{{- if typeIs "string" .value }}
    {{- tpl .value .context }}
{{- else }}
    {{- tpl (.value | toYaml) .context }}
{{- end }}
{{- end -}}

{{/*{{- define "ls-app.endpoint" -}}*/}}
{{/*{{- if .Values.app.ingress.enabled }}http{{ if $.Values.app.ingress.tls }}s{{ end }}://{{ .Values.app.ingress.host }}*/}}
{{/*{{- else }}*/}}
{{/*{{- include "ls-app.fullname" . }}:{{ .Values.app.service.port }}*/}}
{{/*{{- end }}*/}}
{{/*{{- end}}*/}}

{{/*
Set's common environment variables
*/}}
{{- define "ls.common.envs" -}}
{{- if not .Values.global.extraEnvironmentVars.LICENSE }}
{{- if (and .Values.enterprise.enterpriseLicense.secretName .Values.enterprise.enterpriseLicense.secretKey) }}
- name: LICENSE
  valueFrom:
    secretKeyRef:
      name: {{ .Values.enterprise.enterpriseLicense.secretName }}
      key: {{ .Values.enterprise.enterpriseLicense.secretKey }}
{{- end }}
{{- end }}
{{- if not .Values.global.extraEnvironmentVars.DJANGO_DB }}
- name: DJANGO_DB
  value: "default"
{{- end }}
{{- if (and .Values.postgresql.enabled .Values.postgresql.auth.database ) }}
- name: POSTGRE_NAME
  value: {{ .Values.postgresql.auth.database }}
{{- else }}
{{- if .Values.global.pgConfig.dbName }}
- name: POSTGRE_NAME
  value: {{ include "render-values" ( dict "value" .Values.global.pgConfig.dbName "context" $) }}
{{- end }}
{{- end }}
{{- if .Values.global.pgConfig.host }}
- name: POSTGRE_HOST
  value: {{ include "render-values" ( dict "value" .Values.global.pgConfig.host "context" $) }}
{{- else }}
{{- if .Values.postgresql.enabled }}
- name: POSTGRE_HOST
  value: {{ .Release.Name }}-postgresql-hl.{{ .Release.Namespace }}.svc.{{ .Values.clusterDomain }}
{{- end }}
{{- end }}
{{- if (and .Values.postgresql.enabled .Values.postgresql.servicePort) }}
- name: POSTGRE_PORT
  value: {{ .Values.postgresql.servicePort | quote }}
{{- else }}
{{- if .Values.global.pgConfig.port }}
- name: POSTGRE_PORT
  value: {{ .Values.global.pgConfig.port | quote }}
{{- end }}
{{- end }}
{{- if .Values.global.pgConfig.userName }}
- name: POSTGRE_USER
  value: {{ include "render-values" ( dict "value" .Values.global.pgConfig.userName "context" $) }}
{{- else }}
{{- if (and .Values.postgresql.enabled .Values.postgresql.auth.username) }}
- name: POSTGRE_USER
  value: {{ .Values.postgresql.auth.username}}
{{- end }}
{{- end }}
{{- if (and .Values.global.pgConfig.password.secretName .Values.global.pgConfig.password.secretKey) }}
- name: POSTGRE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "render-values" ( dict "value" .Values.global.pgConfig.password.secretName "context" $) }}
      key: {{ include "render-values" ( dict "value" .Values.global.pgConfig.password.secretKey "context" $) }}
{{- else }}
{{- if (and .Values.postgresql.enabled .Values.postgresql.auth.password) }}
- name: POSTGRE_PASSWORD
  value: {{ .Values.postgresql.auth.password }}
{{- end }}
{{- end }}
{{- if .Values.global.redisConfig.host }}
- name: REDIS_LOCATION
  value: {{ include "render-values" ( dict "value" .Values.global.redisConfig.host "context" $) }}
{{- else }}
{{- if .Values.redis.enabled }}
- name: REDIS_LOCATION
  value: redis{{ if .Values.redis.tls.enabled }}s{{ end }}://{{ .Release.Name }}-redis-headless.{{ .Release.Namespace }}.svc.{{ .Values.clusterDomain }}:6379/1
{{- end }}
{{- end }}
{{- if not (hasKey .Values.global.extraEnvironmentVars "LABEL_STUDIO_HOST") }}
{{- if .Values.app.ingress.enabled }}
- name: LABEL_STUDIO_HOST
  value: http{{ if .Values.app.ingress.tls }}s{{ end }}://{{ .Values.app.ingress.host }}{{ default "" .Values.app.contextPath }}
{{- end }}
{{- end }}
{{- if (and .Values.redis.enabled .Values.redis.auth.enabled .Values.redis.auth.password) }}
- name: REDIS_PASSWORD
  value: {{ .Values.redis.auth.password }}
{{- else }}
{{- if (and .Values.global.redisConfig.password.secretName .Values.global.redisConfig.password.secretKey) }}
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "render-values" ( dict "value" .Values.global.redisConfig.password.secretName "context" $) }}
      key: {{ include "render-values" ( dict "value" .Values.global.redisConfig.password.secretKey "context" $) }}
{{- end }}
{{- end }}
- name: PYTHONUNBUFFERED
  value: "1"
- name: LABEL_STUDIO_DOCKER_IMAGE
  value: "{{ coalesce .Values.global.image.tag .Chart.AppVersion }}"
- name: LABEL_STUDIO_DEPLOYMENT_TYPE
  value: "{{ default "helm" .Values.deployment_type }}"
- name: LABEL_STUDIO_CHART_VERSION
  value: {{ .Chart.Version | quote }}
- name: LABEL_STUDIO_CLOUD_PROVIDER
  value: "{{ default "n/a" .Values.cloud_provider }}"
{{- if .Values.global.extraEnvironmentVars -}}
{{- range $key, $value := .Values.global.extraEnvironmentVars }}
- name: {{ printf "%s" $key | replace "." "_" | upper | quote }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}
{{- if .Values.global.extraEnvironmentSecrets -}}
{{- range $key, $value := .Values.global.extraEnvironmentSecrets }}
- name: {{ printf "%s" $key | replace "." "_" | upper | quote }}
  valueFrom:
    secretKeyRef:
      name: {{ $value.secretName }}
      key: {{ $value.secretKey }}
{{- end }}
{{- end }}
- name: STORAGE_PERSISTENCE
  value: "{{ .Values.global.persistence.enabled | default "false" }}"
{{- if .Values.global.persistence.enabled }}
- name: STORAGE_TYPE
  value: {{ .Values.global.persistence.type | quote }}
{{- if eq .Values.global.persistence.type "s3" }}
{{- if or .Values.global.persistence.config.s3.accessKey .Values.global.persistence.config.s3.accessKeyExistingSecret }}
- name: STORAGE_AWS_ACCESS_KEY_ID
  valueFrom:
    secretKeyRef:
      {{- if and .Values.global.persistence.config.s3.accessKeyExistingSecret .Values.global.persistence.config.s3.accessKeyExistingSecretKey }}
      name: {{ .Values.global.persistence.config.s3.accessKeyExistingSecret }}
      key: {{ .Values.global.persistence.config.s3.accessKeyExistingSecretKey }}
      {{- else }}
      name: {{ include "ls-secrets.fullname" . }}
      key: storage-aws-access-key-id
      {{- end }}
{{- end }}
{{- if or .Values.global.persistence.config.s3.secretKey .Values.global.persistence.config.s3.secretKeyExistingSecret }}
- name: STORAGE_AWS_SECRET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      {{- if and .Values.global.persistence.config.s3.secretKeyExistingSecret .Values.global.persistence.config.s3.secretKeyExistingSecretKey }}
      name: {{ .Values.global.persistence.config.s3.secretKeyExistingSecret }}
      key: {{ .Values.global.persistence.config.s3.secretKeyExistingSecretKey }}
      {{- else }}
      name: {{ include "ls-secrets.fullname" . }}
      key: storage-aws-secret-access-key
      {{- end }}
{{- end }}
- name: STORAGE_AWS_REGION_NAME
  value: {{ .Values.global.persistence.config.s3.region | quote }}
- name: STORAGE_AWS_BUCKET_NAME
  value: {{ .Values.global.persistence.config.s3.bucket | quote }}
- name: STORAGE_AWS_FOLDER
  value: {{ .Values.global.persistence.config.s3.folder | quote }}
- name: STORAGE_AWS_X_AMZ_EXPIRES
  value: {{ .Values.global.persistence.config.s3.urlExpirationSecs | quote }}
{{- if .Values.global.persistence.config.s3.endpointUrl }}
- name: STORAGE_AWS_ENDPOINT_URL
  value: {{ .Values.global.persistence.config.s3.endpointUrl | quote }}
{{- end }}
{{- if .Values.global.persistence.config.s3.objectParameters }}
- name: STORAGE_AWS_OBJECT_PARAMETERS
  value: {{ .Values.global.persistence.config.s3.objectParameters | toJson | quote }}
{{- end }}
{{- end }}
{{- if eq .Values.global.persistence.type "azure" }}
- name: STORAGE_AZURE_CONTAINER_NAME
  value: {{ .Values.global.persistence.config.azure.containerName | quote }}
- name: STORAGE_AZURE_FOLDER
  value: {{ .Values.global.persistence.config.azure.folder | quote }}
- name: STORAGE_AZURE_URL_EXPIRATION_SECS
  value: {{ .Values.global.persistence.config.azure.urlExpirationSecs | quote }}
- name: STORAGE_AZURE_ACCOUNT_NAME
  valueFrom:
    secretKeyRef:
      {{- if and .Values.global.persistence.config.azure.storageAccountNameExistingSecret .Values.global.persistence.config.azure.storageAccountNameExistingSecretKey }}
      name: {{ .Values.global.persistence.config.azure.storageAccountNameExistingSecret }}
      key: {{ .Values.global.persistence.config.azure.storageAccountNameExistingSecretKey }}
      {{- else }}
      name: {{ include "ls-secrets.fullname" . }}
      key: storage-azure-account-name
      {{- end }}
- name: STORAGE_AZURE_ACCOUNT_KEY
  valueFrom:
    secretKeyRef:
      {{- if and .Values.global.persistence.config.azure.storageAccountKeyExistingSecret .Values.global.persistence.config.azure.storageAccountKeyExistingSecretKey }}
      name: {{ .Values.global.persistence.config.azure.storageAccountKeyExistingSecret }}
      key: {{ .Values.global.persistence.config.azure.storageAccountKeyExistingSecretKey }}
      {{- else }}
      name: {{ include "ls-secrets.fullname" . }}
      key: storage-azure-account-key
      {{- end }}
{{- end }}
{{- if eq .Values.global.persistence.type "gcs" }}
- name: STORAGE_GCS_BUCKET_NAME
  value: {{ .Values.global.persistence.config.gcs.bucket | quote }}
- name: STORAGE_GCS_PROJECT_ID
  value: {{ .Values.global.persistence.config.gcs.projectID | quote }}
- name: STORAGE_GCS_FOLDER
  value: {{ .Values.global.persistence.config.gcs.folder | quote }}
- name: STORAGE_GCS_EXPIRATION_SECS
  value: {{ .Values.global.persistence.config.gcs.urlExpirationSecs | quote }}
{{- if .Values.global.persistence.config.gcs.applicationCredentialsJSON }}
- name: GOOGLE_APPLICATION_CREDENTIALS
  value: "/opt/heartex/secrets/gcs/key.json"
{{- else if .Values.global.persistence.config.gcs.applicationCredentialsJSONExistingSecretKey }}
- name: GOOGLE_APPLICATION_CREDENTIALS
  value: "/opt/heartex/secrets/gcs/{{ .Values.global.persistence.config.gcs.applicationCredentialsJSONExistingSecretKey }}"
{{- end }}
{{- end }}
{{- if eq .Values.global.persistence.type "volume" }}
- name: USE_NGINX_FOR_EXPORT_DOWNLOADS
  value: "0"
{{- end }}
{{- end }}
{{- if .Values.global.featureFlags -}}
{{- range $key, $value := .Values.global.featureFlags }}
- name: {{ printf "%s" $key | quote }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}
{{- if .Values.global.pgConfig.ssl.pgSslMode }}
- name: POSTGRE_SSL_MODE
  value: {{ .Values.global.pgConfig.ssl.pgSslMode | quote }}
{{- end }}
{{- if .Values.global.pgConfig.ssl.pgSslRootCertSecretKey }}
- name: POSTGRE_SSLROOTCERT
  value: "/opt/heartex/secrets/pg_certs/{{ include "render-values" ( dict "value" .Values.global.pgConfig.ssl.pgSslRootCertSecretKey "context" $) }}"
{{- end }}
{{- if .Values.global.pgConfig.ssl.pgSslCertSecretKey }}
- name: POSTGRE_SSLCERT
  value: "/opt/heartex/secrets/pg_certs/{{ include "render-values" ( dict "value" .Values.global.pgConfig.ssl.pgSslCertSecretKey "context" $) }}"
{{- end }}
{{- if .Values.global.pgConfig.ssl.pgSslKeySecretKey }}
- name: POSTGRE_SSLKEY
  value: "/opt/heartex/secrets/pg_certs/{{ include "render-values" ( dict "value" .Values.global.pgConfig.ssl.pgSslKeySecretKey "context" $) }}"
{{- end }}
{{- if .Values.global.redisConfig.ssl.redisSslCertReqs }}
- name: REDIS_SSL_CERTS_REQS
  value: {{ .Values.global.redisConfig.ssl.redisSslCertReqs | quote }}
- name: REDIS_SSL
  value: "1"
{{- end }}
{{- if .Values.global.redisConfig.ssl.redisSslCaCertsSecretKey }}
- name: REDIS_SSL_CA_CERTS
  value: "/opt/heartex/secrets/redis_certs/{{ include "render-values" ( dict "value" .Values.global.redisConfig.ssl.redisSslCaCertsSecretKey "context" $) }}"
{{- end }}
{{- if .Values.global.redisConfig.ssl.redisSslCertFileSecretKey }}
- name: REDIS_SSL_CERTFILE
  value: "/opt/heartex/secrets/redis_certs/{{ include "render-values" ( dict "value" .Values.global.redisConfig.ssl.redisSslCertFileSecretKey "context" $) }}"
{{- end }}
{{- if .Values.global.redisConfig.ssl.redisSslKeyFileSecretKey }}
- name: REDIS_SSL_KEYFILE
  value: "/opt/heartex/secrets/redis_certs/{{ include "render-values" ( dict "value" .Values.global.redisConfig.ssl.redisSslKeyFileSecretKey "context" $) }}"
{{- end }}
{{- if .Values.global.envInjectSources }}
- name: ENV_INJECT_SOURCES
  value: {{ join "," .Values.global.envInjectSources }}
{{- end }}
{{- if .Values.global.customCaCerts }}
- name: CUSTOM_CA_CERTS
  value: {{ join "," .Values.global.customCaCerts }}
{{- end }}
{{- if .Values.metrics.enabled }}
- name: PROMETHEUS_EXPORT_ENABLED
  value: "1"
{{- end }}
{{- if and (not (hasKey .Values.global.extraEnvironmentSecrets "SECRET_KEY")) (not (hasKey .Values.global.extraEnvironmentVars "SECRET_KEY")) }}
- name: SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "ls-app.fullname" . }}-django-secret
      key: "key"
{{- end }}
{{- if not .Values.global.extraEnvironmentVars.LS_APP_SERVICE_SCHEME }}
- name: LS_APP_SERVICE_SCHEME
  value: "http"
{{- end }}
{{- if not .Values.global.extraEnvironmentVars.LS_APP_SERVICE_NAME }}
- name: LS_APP_SERVICE_NAME
  value: "{{ include "ls-app.fullname" . }}.{{ .Release.Namespace }}"
{{- end }}
{{- if not .Values.global.extraEnvironmentVars.LS_APP_SERVICE_PORT }}
- name: LS_APP_SERVICE_PORT
  value: "{{ .Values.app.service.port }}"
{{- end }}
{{- end -}}


{{- define "capabilities.cronjob.apiVersion" -}}
{{- if semverCompare "<1.21-0" .Capabilities.KubeVersion.Version -}}
{{- print "batch/v1beta1" -}}
{{- else -}}
{{- print "batch/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "render-values" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "render-values" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}