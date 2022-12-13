{{/*
Template for handling deprecation messages

The messages templated here will be combined into a single `fail` call. This creates a means for the user to receive all messages at one time, in place a frustrating iterative approach.

- `define` a new template, prefixed `ls.deprecate.`
- Check for deprecated values / patterns, and directly output messages (see message format below)
- Add a line to `ls.deprecations` to include the new template.

Message format:

**NOTE**: The `if` statement preceding the block should _not_ trim the following newline (`}}` not `-}}`), to ensure formatting during output.

```
component:
    MESSAGE
```
*/}}
{{/*
Compile all deprecations into a single message, and call fail.

Due to gotpl scoping, we can't make use of `range`, so we have to add action lines.
*/}}
{{- define "ls.deprecations" -}}
{{- $deprecated := list -}}
{{/* add templates here */}}
{{- $deprecated = append $deprecated (include "ls.deprecate.featureFlagsAsEnvs" .) -}}

{{- /* prepare output */}}
{{- $deprecated = without $deprecated "" -}}
{{- $message := join "\n" $deprecated -}}

{{- /* print output */}}
{{- if $message -}}
{{-   printf "\nDEPRECATIONS:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Deprecation on feature flags usage as environment variables */}}
{{- define "ls.deprecate.featureFlagsAsEnvs" -}}
{{- if .Values.global.extraEnvironmentVars -}}
{{- range $key, $value := .Values.global.extraEnvironmentVars -}}
{{- if hasPrefix "ff_" (printf "%s" $key | replace "." "_" | lower) }}
ls-app:
  Feature Flags: usage of feature flags in `.Values.global.extraEnvironmentVars` has no effect. Please move all feature flags definitions to `.Values.global.featureFlags`
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{/* END ls.deprecate.featureFlagsAsEnvs */}}