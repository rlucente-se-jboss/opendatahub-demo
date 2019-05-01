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

## Clean it all up
To remove all artifacts simply run the command,

    ./clean.sh

