In this step, you are going to use a [Kopf](https://kopf.readthedocs.io/en/stable/) operator to handle the k8s cluster.

## Installing Kopf
We need to install and prepare some things before we can use the Kopf operator, such as the [pip python package manager](https://pip.pypa.io/en/stable/). In order to do that, use the following commands:
- `apt -q install -y --no-install-recommends python3-pip`{{execute}}
- `pip3 install kopf kubernetes`{{execute}}

In order to use it from the terminal without hassle, add it to the PATH variable as well:
- `echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc`{{execute}}
- `PATH="$HOME/.local/bin:$PATH"`{{execute}}

And finally apply the example custom resource definitions (CRD) of the Kopf on the k8s: `kubectl apply -f https://raw.githubusercontent.com/nolar/kopf/master/examples/crd.yaml`{{execute}}.

## Creating the first Kopf operator
Create a file named `kopf_example.py`{{open}} and paste the following content:

<pre class="file" data-filename="kopf_example.js" data-target="replace">
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
</pre>