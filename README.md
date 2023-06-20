[Website](https://labelstud.io/) • [Docs](https://labelstud.io/guide/) • [Twitter](https://twitter.com/labelstudiohq) • [Join Slack Community <img src="https://app.heartex.ai/docs/images/slack-mini.png" width="18px"/>](https://slack.labelstud.io/?source=github-1)

# The Heartex Library for Kubernetes

Applications, provided by [Heartex](https://heartex.com), ready to launch on Kubernetes using [Kubernetes Helm](https://github.com/helm/helm).

## TL;DR

```bash
$ helm repo add heartex https://charts.heartex.com/
$ helm search repo heartex
$ helm install my-release heartex/<chart>
```

### Prerequisites
- Kubernetes 1.21.x+
- Helm 3.9.x+

### Setup a Kubernetes Cluster

The quickest way to setup a Kubernetes cluster to install Heartex Charts is following the official documentation for the different Cloud Providers:

- [Creating an Amazon EKS cluster](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html)
- [Google Kubernetes Engine (GKE) | How-to guides](https://cloud.google.com/kubernetes-engine/docs/how-to)
- [Deploy an Azure Kubernetes Service (AKS) cluster using the Azure portal](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough-portal)

For setting up Kubernetes on other cloud platforms or bare-metal servers refer to the Kubernetes [getting started guide](http://kubernetes.io/docs/getting-started-guides/).

### Install Helm

Helm is a tool for managing Kubernetes charts. Charts are packages of pre-configured Kubernetes resources.

To install Helm, refer to the [Helm install guide](https://github.com/helm/helm#install) and ensure that the `helm` binary is in the `PATH` of your shell.

### Using Helm

Once you have installed the Helm client, you can deploy a Heartex Helm Chart into a Kubernetes cluster.

Please refer to the [Quick Start guide](https://helm.sh/docs/intro/quickstart/) if you wish to get running in just a few commands, otherwise the [Using Helm Guide](https://helm.sh/docs/intro/using_helm/) provides detailed instructions on how to use the Helm client to manage packages on your Kubernetes cluster.

Useful Helm Client Commands:
* View available charts: `helm search repo heartex`
* Install a chart: `helm install my-release heartex/<chart-name>`
* Upgrade your application: `helm repo update && helm upgrade my-release heartex/<chart-name>`

### Available Helm charts

* [Label Studio](https://github.com/heartexlabs/charts/tree/master/heartex/label-studio)

## Seeking help

If you run into an issue, bug or have a question, please reach out to the Label Studio
community via [Label Studio Slack Community](https://slack.labelstud.io/).


## License

This software is licensed under the [Apache 2.0 LICENSE](/LICENSE) © [Heartex](https://www.heartex.com/). 2020-2022

<img src="https://user-images.githubusercontent.com/12534576/192582529-cf628f58-abc5-479b-a0d4-8a3542a4b35e.png" title="Hey everyone!" width="180" />
