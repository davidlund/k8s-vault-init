# k8s-vault-init

### What is this
Its a hack attempt at integrating vault and kubernetes using vaults kubernetes backend auth [https://www.vaultproject.io/docs/auth/kubernetes.html]. 

I used a kubernetes initializer [https://kubernetes.io/docs/admin/extensible-admission-controllers/#initializers] (Warning - its in alpha!) to automatically create an init-container and volume so your manifests stay short and sweet


### How does it work in a nutshell
* Configure vaults k8s backend (See file demo-manifest/configure-vault.yaml). A ServiceAccount is created for vault to authenticate with k8s with
* An Initializer runs in kubernetes that will automatically add stuff you your manifest if you have the annotation `vault.initializer.kubernetes.io/role`. Disclaimer kelsey hightower did 95% of the code which can be found here [https://github.com/kelseyhightower/kubernetes-initializer-tutorial]. See vault-init-manifest/1.vault-init-definition-configmap.yaml to see what ~junk~ im adding into deployments
* Deployments in kubernetes run with a service account - so under the hood kubernetes mounts a secret volume with that service accounts JWT token. The init-container gets that, posts it to vault to get a single use vault token that can be used to do vault-y things with later
* Vault receives the K8s JWT token posts it back to the K8S api server (using the service account credentials we created mentioned in step one) - it is then able to authenticate that the pod is who they say they are
* There's a lot of stuff around the roles/namespaces - read the code for that stuff. But basically you have to add permissions into vault to say what an account is allowed to use in a namespace/for what role



### Running it
You will need to have minikube installed (tested as v0.24.1)

Run `1.start-minikube.sh` which will start minikube and build the initializer container

It can take a whilst for minikube to start (about 1-2mins) ... you'll have to get over it. If you believe in watching it makes it run ~slower~ faster, you can run `watch -n1 kubectl get pods --all-namespaces`. When everything is running progress

Run `2.deploy-vault-init.sh` which will run the Initializer, register it and deploy a vault in a "secrets" namespace. This should start up within a 10-15 seconds

Lastly Run `3.deploy-demo-app.sh` - this will deploy a nginx in a deployment which is annotated importantly with `vault.initializer.kubernetes.io/role` so will be adjusted by the initialiser

### What i didn't get round to
Storing a cubbyhole secret in vault - using the vault token to download that content so nginx could serve out a juicy secret...
