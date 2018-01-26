
minikube start --memory=2048 --cpus=4 \
--extra-config=apiserver.Admission.PluginNames="Initializers,NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota"

minikube addons disable heapster
minikube addons disable registry
minikube addons disable dashboard

cd vault-kubernetes-initializer && ./build-container.sh & cd ..
