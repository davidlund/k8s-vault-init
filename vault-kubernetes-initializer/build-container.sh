#!/bin/bash
#GOOS=linux go build -a --ldflags '-extldflags "-static"' -tags netgo -installsuffix netgo -o vault-kubernetes-initializer .
GOOS=linux go build  --ldflags '-extldflags "-static"' -tags netgo -installsuffix netgo -o vault-kubernetes-initializer .
eval $(minikube docker-env)
docker build -t vault-kubernetes-initializer:0.0.3 .
rm vault-kubernetes-initializer
