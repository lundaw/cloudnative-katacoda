Now that you have a basic web-server, you can get to testing and playing with the k8s cluster.

## Starting the image in k8s
This is not a recommended practice, but for playing around, start a _single_ pod in the k8s cluster with the web-server.

Execute the `kubectl run hello-pod --image=hello-node:v1`{{execute}} command with which you will start a pod named `hello-pod` with the previously created `hello-node:v1` Docker image running in it.

## Check the status
You can check the status of the pod(s) with the `kubectl get pods`{{execute}} command. If you would like to see more information then you can use the `-o wide` argument, like `kubectl get pods -o wide`{{execute}}. Please note the IP address from the output, you will need it.

Sometimes you need a more processable format, such as YAML. It is available with the `-o yaml` argument. Check the output by executing the `kubectl get pods -o yaml`{{execute}} command. You can view it with highlighting in VS Code, in which case redirect the output: `kubectl get pods -o yaml > hello-pod.yaml`{{execute}} and open the `hello-pod.yaml`{{open}} file.

## Query the web-server
You can query the running web-server by using its IP address and the previously exposed 8080 port with `curl`, like `curl http://<ip address>:8080`.

View the logs with the `kubectl logs hello-pod`{{execute}} command.

### Causing an error
Query the /bye endpoint on the web-server, which will cause an error, because it tries to divide by 0. Call the endpoint with `curl http://<ip address>:8080/bye`.

Do not forget to watch the status with the `watch -n 1 kubectl get pods`{{execute}} command after crashing it as it restarts. If you want to exit the `watch`, use the <key>ctrl</key>+<key>C</key> combination.

### Viewing the logs
View the k8s logs with the `kubectl logs hello-pod`{{execute}} command. If you need previous logs, use `--previous` switch, like `kubectl logs hello-pod --previous`{{execute}}.

## Removing the pod
Now before continuing, remove the running `hello-pod` by executing the `kubectl delete pod hello-pod`{{execute}} command.