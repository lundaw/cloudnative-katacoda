#!/bin/bash

# not necessary
# kubeadm config images pull

# Run kubeadm and set up k8s cluster
kubeadm init --pod-network-cidr=10.244.0.0/16 --kubernetes-version="stable-1.18"

# Set up kube config
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Remove control-plane node isolation and make scheduling possible on the control-plane node
kubectl taint nodes --all node-role.kubernetes.io/master-

# Set up networking
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Signal finish
echo "done" >> /root/setup-finished