Now that you have a basic web-server, you can get to testing and playing with the k8s cluster.

## Starting the image in k8s
This is not a recommended practice, but for playing around, start a _single_ pod in the k8s cluster with the web-server.

Execute the `kubectl run hello-pod --image=hello-node:v1`{{execute}} command with which you will start a pod named `hello-pod` with the previously created `hello-node:v1` Docker image running in it.

## Check the status
You can check the status of the pod(s) with the `kubectl get pods`{{execute}} command. If you would like to see more information then you can use the `-o wide` argument, like `kubectl get pods -o wide`{{execute}}.

Sometimes you need a more processable format, such as YAML. It is available with the `-o yaml` argument. Check the output by executing the `kubectl get pods -o yaml`{{execute}} command. You can view it with highlighting in VS Code, in which case redirect the output: `kubectl get pods -o yaml > hello-pod.yaml`{{execute}} and open the `hello-pod.yaml`{{open}} file.

Now before continuing, remove the running `hello-pod` by executing the `kubectl delete pod hello-pod`{{execute}} command.

## Deploying a scalable web app
Now create a k8s deployment with the same hello-node web-server, but this time with 2 replicas. In order to do that, execute the following commands:
- `kubectl create deployment hello-node --image=hello-node:v1`{{execute}}
- `kubectl scale deployment hello-node --replicas=2`{{execute}}

Check the results with with the `kubectl get pods`{{execute}}. You can view the more verbose information as well with the `kubectl describe pods`{{execute}} command.

### Debugging
If you run into a problem, you can diagnose the pods with the following commands:
- `kubectl get events`{{execute}}
- `kubectl get pods -o wide`{{execute}}
- `kubectl describe pods`{{execute}}

## Service abstraction
Now that we have multiple instances of the web-server, it is not a simple task anymore to find them and talk to them. This is where services are coming to the rescue. Execute the following in the terminal to create a service to the hello-node instances:

```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: hello
spec:
  type: NodePort
  selector:
    app: hello-node
  ports:
  - port: 8080
    targetPort: 8080
    nodePort: 30080
EOF
```{{execute}}

Now you can simply query the web-servers with the `curl http://localhost:30080`{{execute}} and see that both of them will answer if you repeatedly execute the query.