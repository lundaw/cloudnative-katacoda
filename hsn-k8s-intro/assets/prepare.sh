# Add colors to bashrc
printf "
NOCOLOR='\\e[0m'
RED='\\e[0;31m'
GREEN='\\e[0;32m'
ORANGE='\\e[0;33m'
BLUE='\\e[0;34m'
PURPLE='\\e[0;35m'
CYAN='\\e[0;36m'
LIGHTGRAY='\\e[0;37m'
DARKGRAY='\\e[1;30m'
LIGHTRED='\\e[1;31m'
LIGHTGREEN='\\e[1;32m'
YELLOW='\\e[1;33m'
LIGHTBLUE='\\e[1;34m'
LIGHTPURPLE='\\e[1;35m'
LIGHTCYAN='\\e[1;36m'
WHITE='\\e[1;37m'" >> ~/.bashrc
source ~/.bashrc

# Add package repo, install recommended dependencies, set up environment
swapoff -a
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
ech0 -e "${YELLOW}Updating apt package list${NOCOLOR}"
apt -qq update

# Install recommended dependencies and k8s
ech0 -e "${YELLOW}Installing k8s packages and dependencies${NOCOLOR}"
apt -q install -y --no-install-recommends apt-transport-https ebtables kubelet kubeadm kubectl

# Run kubeadm to set up cluster
ech0 -e "${YELLOW}Pulling k8s images and configuring cluster${NOCOLOR}"
kubeadm config images pull
kubeadm init --pod-network-cidr=10.244.0.0/16

# Install kubectl tab completion
ech0 -e "${YELLOW}Configuring kubectl autocompletion${NOCOLOR}"
mkdir -p /etc/bash_completion.d
bash -c 'source /etc/bash_completion'
bash -c 'echo "source <(kubectl completion bash)" > /etc/bash_completion.d/kubectl'

# Set up kube config
ech0 -e "${YELLOW}Copying kube config${NOCOLOR}"
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Remove control-plane node isolation and make scheduling possible on the control-plane node
ech0 -e "${YELLOW}Removing isolation taint from every node${NOCOLOR}"
kubectl taint nodes --all node-role.kubernetes.io/master-

# Set up networking
ech0 -e "${YELLOW}Setting up networking for k8s${NOCOLOR}"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Signal being done
ech0 -e "${GREEN}Environment is ready to use!${NOCOLOR}"