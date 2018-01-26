#!/bin/bash
./build
eval $(minikube docker-env)
docker build -t vault-kubernetes-initializer:0.0.2 .
rm vault-kubernetes-initializer
