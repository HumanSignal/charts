{{/*
Template for checking configuration

The messages templated here will be combined into a single `fail` call. This creates a means for the user to receive all messages at one time, instead of a frustrating iterative approach.

- Pick a location for the new check.
  + Checks of a group reside in a sub file, `_checkConfig_xxx.tpl`.
  + If there isn't a group for that check yet, put it at the end of this file
  + If there are more than 1 check of a same group, extract those checks into a new
  file following the above format. Don't forget to extract the tests too.
- `define` a new template, prefixed `ls.checkConfig.`
- Check for known problems in configuration, and directly output messages (see message format below)
- Add a line to `ls.checkConfig` to include the new template.

Message format:

**NOTE**: The `if` statement preceding the block should _not_ trim the following newline (`}}` not `-}}`), to ensure formatting during output.

```
component:
    MESSAGE
```
*/}}
{{/*
Compile all warnings into a single message, and call fail.

Due to gotpl scoping, we can't make use of `range`, so we have to add action lines.
*/}}
{{- define "ls.checkConfig" -}}
{{- $messages := list -}}
{{/* add templates here */}}

{{/* other checks */}}
{{- $messages = append $messages (include "ls.checkConfig.pgConfig" .) -}}
{{- $messages = append $messages (include "ls.checkConfig.labelStudioHostScheme" .) -}}
{{- $messages = append $messages (include "ls.checkConfig.azureConfig" .) -}}
{{- $messages = append $messages (include "ls.checkConfig.gcsConfig" .) -}}
{{- $messages = append $messages (include "ls.checkConfig.s3Config" .) -}}
{{- $messages = append $messages (include "ls.checkConfig.featureFlagsFFprefix" .) -}}
{{- $messages = append $messages (include "ls.checkConfig.pGandRedisCIonly" .) -}}

{{- $messages = append $messages (include "lse.checkConfig.redisHost" .) -}}
{{- $messages = append $messages (include "lse.checkConfig.redisSslscheme" .) -}}
{{- $messages = append $messages (include "lse.checkConfig.persistenceEnabled" .) -}}
{{- $messages = append $messages (include "lse.checkConfig.ensureLicense" .) -}}

{{- /* prepare output */}}
{{- $messages = without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- /* print output */}}
{{- if $message -}}
{{-   printf "\nCONFIGURATION CHECKS:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Ensure that "LABEL_STUDIO_HOST" has scheme */}}
{{- define "ls.checkConfig.labelStudioHostScheme" -}}
{{- if .Values.global.extraEnvironmentVars.LABEL_STUDIO_HOST -}}
{{- if and (not .Values.app.ingress.enabled) (not (hasPrefix "http" .Values.global.extraEnvironmentVars.LABEL_STUDIO_HOST)) -}}
Label Studio:
  Ingress: Please define scheme http/https in `.Values.global.extraEnvironmentVars.LABEL_STUDIO_HOST`.
  If you're not going to expose the app by 80/443 ports, you also should include the correct port number.
{{- end -}}
{{- end -}}
{{- end -}}
{{/* END ls.checkConfig.labelStudioHostScheme */}}

{{/* Ensure that redis host is set */}}
{{- define "lse.checkConfig.redisHost" -}}
{{- if not .Values.checkConfig.skipEnvValues }}
{{- if and (.Values.enterprise.enabled) (not .Values.redis.enabled) (not .Values.global.redisConfig.host) -}}
Label Studio Enterprise:
  Redis: Redis is required for Label Studio Enterprise. Please set Redis host in `.Values.global.redisConfig.host`
{{- end -}}
{{- end -}}
{{- end -}}
{{/* END ls.checkConfig.redisHost */}}

{{/* Ensure that postgresql host is set */}}
{{- define "ls.checkConfig.pgConfig" -}}
{{- if not .Values.checkConfig.skipEnvValues }}
{{- if (not .Values.postgresql.enabled) -}}
{{- if (not .Values.global.pgConfig.host) -}}
Label Studio:
  PostgreSQL: PostgreSQL is required for Label Studio. Please set PostgreSQL host in `.Values.global.pgConfig.host`
{{ end -}}
{{- if (not .Values.global.pgConfig.dbName) -}}
Label Studio:
  PostgreSQL: Please set database name in `.Values.global.pgConfig.dbName`
{{ end -}}
{{- if (not .Values.global.pgConfig.userName) -}}
Label Studio:
  PostgreSQL: Please set username in `.Values.global.pgConfig.userName`
{{ end -}}
{{- if or (not .Values.global.pgConfig.password.secretName) (not .Values.global.pgConfig.password.secretKey) -}}
Label Studio:
  PostgreSQL: Please ensure that PostgreSQL's password was uploaded in k8s secrets and expose it in `.Values.global.pgConfig.password.secretName` and `.Values.global.pgConfig.password.secretKey`
{{ end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{/* END ls.checkConfig.pgConfig */}}

{{/* Ensure that "rediss" scheme used in connection string */}}
{{- define "lse.checkConfig.redisSslscheme" -}}
{{- if and (.Values.enterprise.enabled) (.Values.global.redisConfig.ssl.redisSslSecretName) (not (hasPrefix "rediss://" .Values.global.redisConfig.host)) -}}
Label Studio Enterprise:
  Redis: In the case if you're using Redis with TLS it's necessary to define the scheme "rediss://" in `.Values.global.redisConfig.host`
{{- end -}}
{{- end -}}
{{/* END ls.checkConfig.redisSslscheme */}}

{{/* Ensure persistence was enabled */}}
{{- define "lse.checkConfig.persistenceEnabled" -}}
{{- if and (.Values.enterprise.enabled) (not .Values.global.persistence.enabled) -}}
Label Studio Enterprise:
  Persistence: You haven't specified a persistence configuration. Data export function will not be supported.
  Data will be persisted on the node running this container, but all data will be lost if this node goes away.
  Please, check our documentation: https://labelstud.io/guide/persistent_storage.html
{{- end -}}
{{- end -}}
{{/* END ls.checkConfig.persistenceEnabled */}}

{{/* Ensure that s3Config is correctly set */}}
{{- define "ls.checkConfig.s3Config" -}}
{{- $s3HelpLink := "Please, check our documentation: https://labelstud.io/guide/persistent_storage.html#Set-up-Amazon-S3" -}}
{{- if eq .Values.global.persistence.type "s3" -}}
{{- if (not .Values.global.persistence.config.s3.region) -}}
Label Studio:
  Persistence(s3): AWS S3 bucket region is required. Please set it in `.Values.global.persistence.config.s3.region`
  {{ $s3HelpLink }}
{{- end -}}
{{- if (not .Values.global.persistence.config.s3.bucket)}}
Label Studio:
  Persistence(s3): AWS S3 bucket name is required. Please set it in `.Values.global.pgConfig.dbName`
  {{ $s3HelpLink }}
{{- end -}}
{{- end -}}
{{- end -}}
{{/* END ls.checkConfig.s3Config */}}

{{/* Ensure that azureConfig is correctly set */}}
{{- define "ls.checkConfig.azureConfig" -}}
{{- $azureHelpLink := "Please, check our documentation: https://labelstud.io/guide/persistent_storage.html#Set-up-Microsoft-Azure-Storage" -}}
{{- if eq .Values.global.persistence.type "azure" -}}
{{- if (not .Values.global.persistence.config.azure.containerName) -}}
Label Studio:
  Persistence(azure): Azure container name is required. Please set it in `.Values.global.persistence.config.azure.containerName`
  {{ $azureHelpLink }}
{{- end -}}
{{- end -}}
{{- end -}}
{{/* END ls.checkConfig.azureConfig */}}

{{/* Ensure that gcsConfig is correctly set */}}
{{- define "ls.checkConfig.gcsConfig" -}}
{{- $gcsHelpLink := "Please, check our documentation: https://labelstud.io/guide/persistent_storage.html#Set-up-Google-Cloud-Storage" -}}
{{- if eq .Values.global.persistence.type "gcs" -}}
{{- if (not .Values.global.persistence.config.gcs.bucket) -}}
Label Studio:
  Persistence(gcs): GCS bucket name is required. Please set it in `.Values.global.persistence.config.gcs.bucket`
  {{ $gcsHelpLink }}
{{- end -}}
{{- if (not .Values.global.persistence.config.gcs.projectID) -}}
Label Studio:
  Persistence(gcs): GCS project ID is required. Please set it in `.Values.global.persistence.config.gcs.projectID`
  {{ $gcsHelpLink }}
{{- end -}}
{{- end -}}
{{- end -}}
{{/* END ls.checkConfig.gcsConfig */}}

{{/* Ensure that feature flags has ff_ or fflag_ prefix */}}
{{- define "ls.checkConfig.featureFlagsFFprefix" -}}
{{- if .Values.global.featureFlags -}}
{{- range $key, $value := .Values.global.featureFlags -}}
{{- if and (not (hasPrefix "ff_" (printf "%s" $key))) (not (hasPrefix "fflag_" (printf "%s" $key))) }}
Label Studio:
  Feature Flags: flags should starts from `ff_` or `fflag_` in lower case. Please check spelling in `.Values.global.featureFlags`
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{/* END ls.checkConfig.featureFlagsFFprefix */}}

{{/* Ensure that PG and Redis are not used in Production */}}
{{- define "ls.checkConfig.pGandRedisCIonly" -}}
{{- if and (.Values.enterprise.enabled) (not .Values.ci) -}}
{{- if or .Values.redis.enabled .Values.postgresql.enabled }}
Label Studio:
  Redis/PostgreSQL: provided Helm chart dependencies should be used only for CI purposes.
{{- end -}}
{{- end -}}
{{- end -}}
{{/* END ls.checkConfig.pGandRedisCIonly */}}

{{/* Ensure that the license is set */}}
{{- define "lse.checkConfig.ensureLicense" -}}
{{- if not .Values.checkConfig.skipEnvValues }}
{{- if and (.Values.enterprise.enabled) (not (hasKey .Values.global.extraEnvironmentVars "LICENSE")) (not .Values.enterprise.enterpriseLicense.secretName) -}}
Label Studio Enterprise:
  License: License file should be set either using k8s secret (`.Values.enterprise.enterpriseLicense.secretName`, `.Values.enterprise.enterpriseLicense.secretKey`) or as URL in `.Values.global.extraEnvironmentVars.LICENSE`
{{- end -}}
{{- end -}}
{{- end -}}
{{/* END ls.checkConfig.ensureLicense */}}