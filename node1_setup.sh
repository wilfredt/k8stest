#!/bin/bash

# Start the master and apply CNI
kubeadm init --apiserver-advertise-address $(hostname -i)
kubectl apply -n kube-system -f \
    "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 |tr -d '\n')"

# apply kubectl auto-completion
source <(kubectl completion bash)

# Add some packages for easier usage
yum install binutils vim net-tools -y
