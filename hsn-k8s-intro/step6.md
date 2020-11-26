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

Now before you continue, restart the Kopf operator in the other Terminal window to apply the changes made in the `kopf_example.py` file. You can do that by pressing <kbd>CTRL</kbd>+<kbd>C</kbd> and executing the previously used `kopf run` command. Or in one step by pressing this: `kopf run --namespace default --standalone kopf_example.py`{{execute interrupt T1}}.

### Testing the modifications
After you made the changes to the Kopf operator and restarted it, you can test it by creating a custom resource with the following in the second Terminal window:
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
```{{execute T2}}

Now if you check the output in the first terminal window, you will see a new line with `Spec value is: ...`.