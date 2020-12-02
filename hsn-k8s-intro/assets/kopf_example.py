import kopf
import kubernetes

pods = {}

@kopf.on.create('', 'v1', 'pods')
def create_fn(name, spec, logger, **kwargs):
    pods[name] = spec
    logger.info(f"Creating: {name}. There are {len(pods)} pods.")

@kopf.on.resume('', 'v1', 'pods')
def resume_fn(name, spec, logger, **kwargs):
    pods[name] = spec
    logger.info(f"Resuming: {name}. There are {len(pods)} pods.")

@kopf.on.delete('', 'v1', 'pods')
def delete_fn(name, logger, **kwargs):
    try:
        del pods[name]
    except KeyError:
        pass
    logger.info(f"Deleting: {name}. There are {len(pods)} pods.")

@kopf.on.create('zalando.org', 'v1', 'kopfexamples')
def create_zalando_fn(name, spec, logger, **kwargs):
    pods[name] = spec
    logger.info(f"Resuming: {name}. There are {len(pods)} pods.")
    logger.info(f"Spec value is: {spec}")