If you have not done it yet, delete the `hello-node` deployment with `kubectl delete deployment hello-node`{{execute T2}}.

## Extending Kopf to scale
Now you need to extend the python code to do the scaling as well and keep the number of pods up-to-date with the spec.replicas value. In order to see the difference, the new code configuration will be the `kopf_scaling.py`{{open}} file.

### Scaling, pod creation and deletion
First, you will need to handle the scaling, the pod creation and deletion with the operator. It can be solved with the following code:
<pre class="file" data-filename="kopf_scaling.py" data-target="replace">
import random
import kopf
import kubernetes

pods = {}               # Current pods in the cluster
target = 0              # Number of pods as a goal
template_spec = None    # Spec of the automatically created pods
base_name = ""

def scale(logger):
    "Handle the scaling of the pods."

    if len(pods) == target:
        return
    
    if len(pods) > target:
        name = random.choice(list(pods.keys()))
        delete_pod(logger, name)
        return

    if len(pods) < target:
        # The following could cause name collision. What would happen in that case?
        suffix = random.randint(0, 20)
        name = f'{base_name}-{suffix}'
        create_pod(logger, name, template_spec)

def create_pod(logger, name, spec)
    "Creates a pod named NAME with SPEC specification."
    logger.info(f'Creating {name} pod')
    api = kubernetes.client.CoreV1Api()
    data = {
        "metadata": {
            "name": name
        },
        "spec": spec
    }
    obj = api.create_namespaced_pod(namespace="default", body=data)

def delete_pod(logger, name):
    "Delete the pod named NAME."
    logger.info(f'Deleting {name} pod')
    api = kubernetes.client.CoreV1Api()
    api.delete_namespaced_pod(namespace="default", name=name)

</pre>

### Event handlers
Second you will need to have event handlers with the operator to watch for events and do what you need.

#### Kopfexamples
These event handlers will watch for the `kopfexamples` and handle those events. For simplicity, the solution is combining the annotations.

<pre class="file" data-filename="kopf_scaling.py" data-target="append">
@kopf.on.create("zalando.org", "v1", "kopfexamples")
@kopf.on.resume("zalando.org", "v1", "kopfexamples")
@kopf.on.update("zalando.org", "v1", "kopfexamples")
def handle_kopfexamples_event(name, spec, logger, **kwargs):
    global base_name, template_spec, target
    base_name = name
    template_spec = spec["template"]["spec"]
    target = spec["replicas"]

    logger.info(f"handle_example_event: {name}. Target is {target}.")
    scale(logger)

@kopf.on.delete("zalando.org", "v1", "kopfexamples")
def handle_kopfexamples_delete(name, logger, **kwargs):
    target = 0
    logger.info(f"handle_kopfexamples_delete: {name}. Target is {target}.")
    scale(logger)

</pre>

#### Pods
And now add the event handlers for pods.

<pre class="file" data-filename="kopf_scaling.py" data-target="append">
@kopf.on.create('', 'v1', 'pods')
def handle_pod_created(name, spec, logger, **kwargs):
    # Called when a new pod is added to the k8s cluster.
    pods[name] = spec  # Save spec
    logger.info(f"handle_pod_created: {name}. There are {len(pods)} pods.")
    scale(logger)

@kopf.on.resume('', 'v1', 'pods')
def handle_pod_resumed(name, spec, logger, **kwargs):
    # Called with pods created before our operator started."
    pods[name] = spec
    logger.info(f"handle_pod_resumed: {name}. There are {len(pods)} pods.")
    scale(logger)

@kopf.on.delete('', 'v1', 'pods')
def handle_pod_deleted(name, logger, **kwargs):
    # Called when a pod is deleted from the cluster."
    try:
        del pods[name]
    except KeyError:
        pass
    logger.info(f"handle_pod_deleted: {name}. There are {len(pods)} pods.")
    scale(logger)
</pre>

## Testing the scaling
Before testing and using, restart the Kopf operator with the new python code with `kopf run --namespace default --standalone kopf_scaling.py`{{execute interrupt T1}}.

You can test the scaling by modifying the previously added configuration with `kubectl edit kopfexamples kopf-example-1`{{execute T2}} and changing the replica values.