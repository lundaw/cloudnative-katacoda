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

### Crashing
You can also try out the same method as the previous step and intentionally crash the web-server and check the results. As a reminder, the endpoint to the division by 0 was `/die`.

If you make one request to it and the others normally, the remaining instance will still answer. Meanwhile the crashed one will be automatically restarted.