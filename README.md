# The Heartex Library for Kubernetes

Applications, provided by [Heartex](https://heartex.com), ready to launch on Kubernetes using [Kubernetes Helm](https://github.com/helm/helm).

## TL;DR

```bash
$ helm repo add heartex https://charts.heartex.com/heartex
$ helm search repo heartex
$ helm install my-release heartex/<chart>
```

## Before you begin

### Prerequisites
- Kubernetes 1.19.x+
- Helm 3.7.x+

### Setup a Kubernetes Cluster

The quickest way to setup a Kubernetes cluster to install Heartex Charts is following the official documentation for the different Cloud Providers:

- [Creating an Amazon EKS cluster](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html)
- [Google Kubernetes Engine (GKE) | How-to guides](https://cloud.google.com/kubernetes-engine/docs/how-to)
- [Deploy an Azure Kubernetes Service (AKS) cluster using the Azure portal](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough-portal)

For setting up Kubernetes on other cloud platforms or bare-metal servers refer to the Kubernetes [getting started guide](http://kubernetes.io/docs/getting-started-guides/).

### Install Helm

Helm is a tool for managing Kubernetes charts. Charts are packages of pre-configured Kubernetes resources.

To install Helm, refer to the [Helm install guide](https://github.com/helm/helm#install) and ensure that the `helm` binary is in the `PATH` of your shell.

### Add Repo

The following command allows you to download and install all the charts from this repository:

```bash
$ helm repo add heartex https://charts.heartex.com/heartex
```

### Using Helm

Once you have installed the Helm client, you can deploy a Heartex Helm Chart into a Kubernetes cluster.

Please refer to the [Quick Start guide](https://helm.sh/docs/intro/quickstart/) if you wish to get running in just a few commands, otherwise the [Using Helm Guide](https://helm.sh/docs/intro/using_helm/) provides detailed instructions on how to use the Helm client to manage packages on your Kubernetes cluster.

Useful Helm Client Commands:
* View available charts: `helm search repo`
* Install a chart: `helm install my-release heartex/<package-name>`
* Upgrade your application: `helm upgrade`
