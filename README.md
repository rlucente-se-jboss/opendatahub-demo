# opendatahub-demo
This repository scripts out how to install the
[OpenDataHub](https://opendatahub.io) demo on OpenShift.

## Configure the demo
### One time registry authentication configuration
With OCP 3.11, the [Red Hat container registry](https://registry.redhat.io)
now restricts pulling images to authenticated users.  To get your
credentials, go to the [Red Hat container registry](https://registry.redhat.io)
and click on the `Service Accounts` link in the center right of the
page.  You may need to login first using your [Red Hat Customer Portal](https://access.redhat.com)
credentials.  Scroll until you find your account or click `New
Service Account` to create one.  Click on your service account.
Make sure the `Docker Login` tab is selected and run the example
command on your local computer.  Inspect the file $HOME/.docker/config.json
on your local computer and make sure it only contains the `auths`
entry for `registry.redhat.io`.  Secure copy this to the OpenShift
nodes in your OpenShift cluster using:

    scp ~/.docker/config.json \
        root@<node-ip-address>:/var/lib/origin/.docker/config.json

Make sure that the secret `imagestreamsecret` in the `openshift`
project on the cluster matches.  To do that, run the following
commands as a user with `cluster-admin` privileges:

    oc delete secret/imagestreamsecret -n openshift
    oc create secret generic imagestreamsecret \
        --from-file=.dockerconfigjson=$HOME/.docker/config.json \
        --type=kubernetes.io/dockerconfigjson \
        -n openshift

Restart the OpenShift compute node.

### Configure the demo parameters    
Set the three `APB_` parameters to correctly pull the latest
[automation broker](http://automationbroker.io/) for your platform.
The example in the `demo.conf` file is correct for Mac OSX.

Finally, set the `IP_ADDR`, `DOMAIN`, `MASTER`, and `PORT` to
correctly resolve to the OpenShift API on the master node.

## Install the demo
Everything is scripted and straightforward.  Simply run the command,

    ./setup.sh

The automation broker will ask several questions to configure the
opendatahub-demo.  Example answers are provided below in bold.

<pre><code>
Enter name of plan to execute: <b>dev</b>
Plan: dev
Enter value for parameter [db_memory], default: [256Mi]: <b>1Gi</b>
Enter value for parameter [jupyterhub_memory], default: [256Mi]: <b>1Gi</b>
Enter value for parameter [s3_endpoint_url], default: [http://ceph:8000]:
Enter value for parameter [storage_class] (Storage class to be used for all the PVCs in the app), default: [<nil>]:
Enter value for parameter [spark_operator] (Deploy spark operator?), default: [true]:
Enter value for parameter [deploy_all_notebooks] (Add all Jupyter notebook images (resource heavy while building)), default: [false]: <b>true</b>
Enter value for parameter [registry] (URL of registry to pull images from (optional; images will be built if not provided)), default: [<nil>]:
Enter value for parameter [repository] (Name of the image repository in the registry (mandatory if registry is provided)), default: [<nil>]:
</code></pre>

## Clean it all up
To remove all artifacts simply run the command,

    ./clean.sh

