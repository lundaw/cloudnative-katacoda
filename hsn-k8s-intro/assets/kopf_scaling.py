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

def create_pod(logger, name, spec):
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