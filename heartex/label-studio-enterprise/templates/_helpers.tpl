{{/*
Expand the name
*/}}
{{- define "lse-app.name" -}}
{{- default "lse-app" .Values.app.NameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "lse-rqworker.name" -}}
{{- default "lse-rqworker" .Values.rqworker.NameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "lse-app.fullname" -}}
{{- if .Values.app.FullnameOverride }}
{{- .Values.app.FullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "lse-app" .Values.app.FullnameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "lse-rqworker.fullname" -}}
{{- if .Values.rqworker.FullnameOverride }}
{{- .Values.rqworker.FullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "lse-rqworker" .Values.rqworker.FullnameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "lse.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels for lse-app
*/}}
{{- define "lse-app.labels" -}}
helm.sh/chart: {{ include "lse.chart" . }}
{{ include "lse-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for lse-app
*/}}
{{- define "lse-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lse-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels for lse-rqworker
*/}}
{{- define "lse-rqworker.labels" -}}
helm.sh/chart: {{ include "lse.chart" . }}
{{ include "lse-rqworker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for lse-rqworker
*/}}
{{- define "lse-rqworker.selectorLabels" -}}
app.kubernetes.io/part-of: label-studio-enterprise
app.kubernetes.io/name: {{ include "lse-rqworker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the app service account to use
*/}}
{{- define "lse-app.serviceAccountName" -}}
{{- if .Values.app.serviceAccount.create }}
{{- default (include "lse-app.fullname" .) .Values.app.serviceAccount.name }}
{{- else }}
{{- default "lse" .Values.app.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the rqworker service account to use
*/}}
{{- define "lse-rqworker.serviceAccountName" -}}
{{- if .Values.rqworker.serviceAccount.create }}
{{- default (include "lse-rqworker.fullname" .) .Values.rqworker.serviceAccount.name }}
{{- else }}
{{- default "rqworker" .Values.rqworker.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*{{- define "lse-app.endpoint" -}}*/}}
{{/*{{- if .Values.app.ingress.enabled }}http{{ if $.Values.app.ingress.tls }}s{{ end }}://{{ .Values.app.ingress.host }}*/}}
{{/*{{- else }}*/}}
{{/*{{- include "lse-app.fullname" . }}:{{ .Values.app.service.port }}*/}}
{{/*{{- end }}*/}}
{{/*{{- end}}*/}}

{{/*
Set's common environment variables
*/}}
{{- define "lse.common.envs" -}}
          {{- if (and .Values.global.enterpriseLicense.secretName .Values.global.enterpriseLicense.secretKey) }}
            - name: LICENSE
              valueFrom:
                secretKeyRef:
                  name: {{ .Values.global.enterpriseLicense.secretName }}
                  key: {{ .Values.global.enterpriseLicense.secretKey }}
          {{- end }}
            - name: SKIP_DB_MIGRATIONS
              value: "{{ .Values.global.skipDbMigrations | default "true" }}"
            - name: DJANGO_DB
              value: {{ .Values.global.djangoConfig.db }}
            - name: DJANGO_SETTINGS_MODULE
              value: {{ .Values.global.djangoConfig.settings_module }}
            {{- if (and .Values.postgresql.enabled .Values.postgresql.postgresqlDatabase) }}
            - name: POSTGRE_NAME
              value: {{ .Values.postgresql.postgresqlDatabase }}
            {{- else }}
            {{- if .Values.global.pgConfig.dbName }}
            - name: POSTGRE_NAME
              value: {{ .Values.global.pgConfig.dbName }}
            {{- end }}
            {{- end }}
            {{- if .Values.postgresql.enabled }}
            - name: POSTGRE_HOST
              value: {{ .Release.Name }}-postgresql-headless
            {{- else }}
            {{- if .Values.global.pgConfig.host }}
            - name: POSTGRE_HOST
              value: {{ .Values.global.pgConfig.host }}
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
            {{- if (and .Values.postgresql.enabled .Values.postgresql.postgresqlUsername) }}
            - name: POSTGRE_USER
              value: {{ .Values.postgresql.postgresqlUsername}}
            {{- else }}
            {{- if .Values.global.pgConfig.userName }}
            - name: POSTGRE_USER
              value: {{ .Values.global.pgConfig.userName }}
            {{- end }}
            {{- end }}
            {{- if (and .Values.postgresql.enabled .Values.postgresql.postgresqlPassword) }}
            - name: POSTGRE_PASSWORD
              value: {{ .Values.postgresql.postgresqlPassword }}
            {{- else }}
            {{- if (and .Values.global.pgConfig.password.secretName .Values.global.pgConfig.password.secretKey) }}
            - name: POSTGRE_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: {{ .Values.global.pgConfig.password.secretName }}
                  key: {{ .Values.global.pgConfig.password.secretKey }}
            {{- end }}
            {{- end }}
            - name: REDIS_LOCATION
              value: {{ if .Values.redis.enabled }}redis://{{ .Release.Name }}-redis-headless:6379/1{{ else }}{{ .Values.global.redisConfig.host }}{{ end }}
            {{- if not .Values.global.extraEnvironmentVars.LABEL_STUDIO_HOST }}
            - name: LABEL_STUDIO_HOST
            {{- if .Values.app.ingress.enabled }}
              value: http{{ if .Values.app.ingress.tls }}s{{ end }}://{{ .Values.app.ingress.host }}{{ default "" .Values.global.contextPath }}
            {{- else }}
              value: http://127.0.0.1:8080
            {{- end }}
            {{- end }}
            {{- if (and .Values.global.redisConfig.password.secretName .Values.global.redisConfig.password.secretKey) }}
            - name: REDIS_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: {{ .Values.global.redisConfig.password.secretName }}
                  key: {{ .Values.global.redisConfig.password.secretKey }}
            {{- end }}
            - name: PYTHONUNBUFFERED
              value: "1"
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
            {{- if .Values.minio.enabled }}
            - name: MINIO_STORAGE_MEDIA_USE_PRESIGNED
              value: "false"
            - name: MINIO_STORAGE_BUCKET_NAME
              value: "media"
            - name: MINIO_STORAGE_ENDPOINT
              value: http://{{ .Release.Name }}-minio:9000
            {{- if .Values.minio.accessKey.password }}
            - name: MINIO_STORAGE_ACCESS_KEY
              value: {{ .Values.minio.accessKey.password | quote }}
            {{- else }}
            - name: MINIO_STORAGE_ACCESS_KEY
              valueFrom:
                secretKeyRef:
                  name: {{ .Release.Name }}-minio
                  key: access-key
            {{- end }}
            {{- if .Values.minio.secretKey.password }}
            - name: MINIO_STORAGE_SECRET_KEY
              value: {{ .Values.minio.secretKey.password | quote }}
            {{- else }}
            - name: MINIO_STORAGE_SECRET_KEY
              valueFrom:
                secretKeyRef:
                  name: {{ .Release.Name }}-minio
                  key: secret-key
            {{- end }}
            {{- end }}
{{- end -}}