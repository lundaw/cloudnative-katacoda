In this step, you will prepare the k8s environment by installing the necessary packages for managing it.

## Necessary packages
K8s is mainly based on and managed by 3 packages:
- kubelet
- kubeadm
- kubectl

### kubelet
Kubelet is the agent that runs on each node in the k8s cluster and it makes sure that the containers are running and healthy in a Pod.

For more detailed information, you can check out the documentation: [Kubernetes components - kubelet](https://kubernetes.io/docs/concepts/overview/components/#kubelet).

### kubeadm
Kubeadm is built to help creating k8s clusters in simple step(s), based on "best-practice". Its main job is to bootstrap the k8s control-plane node.

For more information, you can read the documentation at [Kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/).

### kubectl
Kubectl, as its name suggests, is a tool to manage the k8s clusters, based on the config file located in the `$HOME/.kube` directory.

For more information, the documentation at [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) is great.

## Prepare the environment
Now that you know the installed packages and how they help you manage and run k8s clusters, prepare the environment by running the provided bash script.

The script is added to the binaries, you only need to give the `prepare.sh`{{execute}} command to execute it and wait until it finishes.