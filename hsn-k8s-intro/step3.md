Now that you have a basic web-server, you can get to testing and playing with the k8s cluster.

## Starting the image in k8s
This is not a recommended practice, but for playing around, start a _single_ pod in the k8s cluster with the web-server.

Execute the `kubectl run hello-pod --image=hello-node:v1`{{execute}} command with which you will start a pod named `hello-pod` with the previously created `hello-node:v1` Docker image running in it.

## Check the status
You can check the status of the pod(s) with the `kubectl get pods`{{execute}} command. If you would like to see more information then you can use the `-o wide` argument, like `kubectl get pods -o wide`.

Sometimes you need a more processable format, such as YAML. It is available with the `-o yaml` argument. Check the output by executing the `kubectl get pods -o yaml`{{execute}} command. You can view it with highlighting in VS Code, in which case redirect the output: `kubectl get pods -o yaml > hello-pod.yaml`{{execute}} and open the `hello-pod.yaml`{{open}} file.