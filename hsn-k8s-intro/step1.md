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

## Prepare the environment
Run the `prepare.sh`{{execute}} script to prepare the environment by installing packages, setting up a basic k8s cluster.