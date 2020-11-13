# Add package repo, install recommended dependencies, set up environment
swapoff -a
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt update

# Install recommended dependencies and k8s
apt install -y apt-transport-https ebtables kubelet kubeadm kubectl

# Run kubeadm to set up cluster
kubeadm config images pull
kubeadm init --pod-network-cidr=10.244.0.0/16

# Install kubectl tab completion
mkdir -p /etc/bash_completion.d
bash -c 'source /etc/bash_completion'
bash -c 'echo "source <(kubectl completion bash)" > /etc/bash_completion.d/kubectl'

# Set up kube config
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Remove control-plane node isolation and make scheduling possible on the control-plane node
kubectl taint nodes --all node-role.kubernetes.io/master-

# Set up networking
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml