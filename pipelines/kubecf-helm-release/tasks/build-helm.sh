#!/usr/bin/env sh

exec 3> `basename "$0"`.trace
BASH_XTRACEFD=3

set -ex

export PATH=$PATH:$PWD/bin
export GOPATH=$PWD
export GO111MODULE=on

pushd src/code.cloudfoundry.org/kubecf-helm
. bin/include/versioning
popd

make -C src/code.cloudfoundry.org/kubecf-helm build-helm
cp src/kubecf.s3.amazonaws.com/kubecf/helm/kubecf*.tgz helm-charts/

SHA256=$(sha256sum src/kubecf.s3.amazonaws.com/kubecf/helm/kubec*.tgz | cut -f1 -d ' ' )
version=$(echo "$ARTIFACT_VERSION" | sed 's/^v//; s/-/+/')
echo $SHA256 > shas/$version
