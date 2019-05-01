# opendatahub-demo
This repository scripts out how to install the
[OpenDataHub](https://opendatahub.io) demo on OpenShift.

## Configure the demo
With OCP 3.11, the [Red Hat container registry](https://registry.redhat.io)
now restricts pulling images to authenticated users.  To get your
credentials, go to the [Red Hat container registry](https://registry.redhat.io)
and click on the `Service Accounts` link in the center right of the
page.  Scroll until you find your account or click `New Service
Account` to create one.  Click on your service account.  Make sure
the `Token Information` tab is selected and copy your username and
password to the parameters `OREG_USER` and `OREG_PASS`, respectively,
in the `demo.conf` file.  Make sure the username includes the
random number, the vertical bar, and the service account name.

Set the three `APB_` parameters to correctly pull the latest
[automation broker](http://automationbroker.io/) for your platform.
The example in the `demo.conf` file is correct for Mac OSX.

For the `SECRET_NAME`, you can follow the convention of your email
address but substitue a dash `-` for the `@` sign (e.g.
rlucente-example.com).

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

