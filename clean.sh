#!/usr/bin/env bash

. $(dirname $0)/demo.conf

oc logout
oc login -u ${USER} -p ${PASS} https://${MASTER}:${PORT}

oc project ${PROJECT}

oc delete all --all -n ${PROJECT}
oc delete project ${PROJECT}

for i in $(oc get pv | grep -v Available | grep '^vol' | awk '{print $1}')
do
    oc patch pv/$i --type json -p $'- op: remove\n  path: /spec/claimRef'
done

#
# remove any left over data on persistent volumes (this assumes
# persistent volumes are located under /mnt/data on the host at
# $IP_ADDR)
#
echo
echo "************************************************************************"
echo "Provide the root password for ${IP_ADDR} if prompted"
ssh root@${IP_ADDR} 'cd /mnt/data && find . -type d | grep "^./vol[0-9]*/" | cut -d/ -f1-3 | sort -u | xargs rm -fr'
echo

