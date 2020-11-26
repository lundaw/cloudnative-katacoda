## Extending the previous config
Now you are going to extend the previous Kopf configuration by adding handlers for `('zalando.org', 'v1', 'kopfexamples')` and printing the `spec` field. In order to do that, you need to extend the `kopf_example.py`{{open}} file.

You can do that by adding a new function with the annotation to the python code:
<pre class="file" data-filename="kopf_example.py" data-target="append">
@kopf.on.create('zalando.org', 'v1', 'kopfexamples')
def create_zalando_fn(name, spec, logger, **kwargs):
    pods[name] = spec
    logger.info(f"Resuming: {name}. There are {len(pods)} pods.")
    logger.info(f"Spec value is: {spec}")
</pre>

### Testing the modifications
After you made the changes to the Kopf operator, you can test it by creating a custom resource with the following:
```
kubectl apply -f - <<EOF
apiVersion: zalando.org/v1
kind: KopfExample
metadata:
  name: kopf-example-1
spec:
  replicas: 4
  app: hello-node
  template:
    metadata:
      labels:
        app: hello-node
    spec:
      containers:
      - name: the-only-one
        image: hello-node:v1
EOF
```{{execute}}