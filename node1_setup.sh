#!/bin/bash

# Start the master and apply CNI
kubeadm init --apiserver-advertise-address $(hostname -i) 2>&1 |tee -a ~/kubeadm_init.log
kubectl apply -n kube-system -f \
    "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 |tr -d '\n')"

# Add some packages for easier usage
yum install binutils vim net-tools openssl grep bash-completion -y

# apply kubectl auto-completion
echo "source <(kubectl completion bash)" >> ~/.bashrc
#
echo see ~/kubeadm_init.log for kubeadm logs

echo "To join in other nodes:"
echo "kubeadm join https://$(kubectl cluster-info |grep master|egrep -o 'https://\S+') --token $(kubeadm token list|grep authentication|cut -d' ' -f1) --discovery-token-ca-cert-hash sha256:$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null |openssl dgst -sha256 -hex|sed 's/^.* //')"

# 
bash
