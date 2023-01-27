# Frequently Asked Questions (FAQs)

### Label Studio Enterprise: Upgrade from decommissioned label-studio-enterprise Helm chart

Edit your lse-values.yaml file.

1. Add `global.image.repository` and set `global.image.tag` to a version equal or newer `2.3.1`:
```yaml
global:
  image:
    repository: heartexlabs/label-studio-enterprise
    tag: 2.3.1
```

2. Move `global.enterpriseLicense` and all sub-keys to `enterprise` (so `enterprise` will on the same level as `global`, `app` or `rqworker`) and set `enterprise.enabled` to `true`:
```yaml
enterprise:
  enabled: true
  enterpriseLicense:
    secretName: "lse-license"
    secretKey: "license"
```

3. Disable self-provisioned SQL instance:
```yaml
postgresql:
  enabled: false
```

4. Completely remove properties `app.logLevel`, `app.debug`, `rqworker.logLevel`, `rqworker.debug`, `minio.*`.

5. Set `app.ingress.enabled` to `true`:
```yaml
app:
  ingress:
    enabled: true
```

6. Get the current release name using `helm list` command.
7. Run upgrade command using new helm chart:
```shell
helm upgrade RELEASE_NAME heartex/label-studio -f lse-values.yaml
```


### Error: UPGRADE FAILED: failed to create resource: admission webhook "validate.nginx.ingress.kubernetes.io" denied the request: host "xxx" and path "/" is already defined in ingress kube-system/xxx-lse-app

Remove `ValidatingWebhookConfiguration` resource:
```shell
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
```
