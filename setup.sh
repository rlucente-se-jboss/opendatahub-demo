#!/usr/bin/env bash

. $(dirname $0)/demo.conf

PUSHD ${WORKDIR}

    # install both oc and aws command line (for OSX)
    brew update && brew upgrade && brew install awscli openshift-cli

    ./clean.sh

    oc logout
    oc login -u ${USER} -p ${PASS} ${MASTER}:${PORT}

    oc delete project ${PROJECT}
    oc new-project ${PROJECT}

    curl -sLO https://$APB_URL/apb-$APB_VER/$APB_BIN

    chmod a+x $APB_BIN
    mv -f $APB_BIN ~/NotBackedUp
    rm -f /usr/local/bin/apb
    ln -s ~/NotBackedUp/$APB_BIN /usr/local/bin/apb

    docker login -u="${OREG_USER}" -p="${OREG_PASS}" registry.redhat.io

    oc create secret generic ${SECRET_NAME} \
        --from-file=.dockerconfigjson=$HOME/.docker/config.json \
        --type=kubernetes.io/dockerconfigjson
    oc secrets link default ${SECRET_NAME} --for=pull
    oc secrets link builder ${SECRET_NAME}

    apb registry add opendatahub --type quay --org opendatahub
    apb bundle list

    oc --as system:admin adm policy add-scc-to-user anyuid system:serviceaccount:${PROJECT}:default

    apb bundle provision jupyterhub-apb --namespace ${PROJECT} -s admin

    S3_BUCKET_NAME="MY-DATA"

    echo "Set the S3 access key to 'foo' and the S3 secret key to 'bar'"
    echo "Leave the remaining items blank"
    aws configure

    echo
    echo "    # Instruct openshift to forward a localhost port to the ceph container"
    echo "    oc port-forward ceph-nano-0 8000 &"
    echo
    echo "    # Default S3 access key: foo"
    echo "    # Default S3 secret key: bar"
    echo "    export S3_BUCKET_NAME=\"MY-DATA\""
    echo
    echo "    # Now you can specify an endpoint url as the loopback address listening on the forwarded port"
    echo "    aws --endpoint-url http://127.0.0.1:8000 s3 mb s3://\${S3_BUCKET_NAME}"
    echo "    aws --endpoint-url http://127.0.0.1:8000 s3 cp \${DATA_FILENAME} s3://\${S3_BUCKET_NAME}"
    echo "    aws --endpoint-url http://127.0.0.1:8000 s3 ls s3://\${S3_BUCKET_NAME}"
    echo

POPD

