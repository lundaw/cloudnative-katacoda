# Add colors to bashrc
printf "
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'" >> ~/.bashrc
source ~/.bashrc

# Add package repo, install recommended dependencies, set up environment
swapoff -a
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
echo "${YELLOW}Updating apt package list${NOCOLOR}"
apt -qq update

# Install recommended dependencies and k8s
echo "${YELLOW}Installing k8s packages and dependencies${NOCOLOR}"
apt -q install -y --no-install-recommends apt-transport-https ebtables kubelet kubeadm kubectl

# Run kubeadm to set up cluster
echo "${YELLOW}Pulling k8s images and configuring cluster${NOCOLOR}"
kubeadm config images pull
kubeadm init --pod-network-cidr=10.244.0.0/16

# Install kubectl tab completion
echo "${YELLOW}Configuring kubectl autocompletion${NOCOLOR}"
mkdir -p /etc/bash_completion.d
bash -c 'source /etc/bash_completion'
bash -c 'echo "source <(kubectl completion bash)" > /etc/bash_completion.d/kubectl'

# Set up kube config
echo "${YELLOW}Copying kube config${NOCOLOR}"
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Remove control-plane node isolation and make scheduling possible on the control-plane node
echo "${YELLOW}Removing isolation taint from every node${NOCOLOR}"
kubectl taint nodes --all node-role.kubernetes.io/master-

# Set up networking
echo "${YELLOW}Setting up networking for k8s${NOCOLOR}"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Signal being done
echo "${GREEN}Environment is ready to use!${NOCOLOR}"