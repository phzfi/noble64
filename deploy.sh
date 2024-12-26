#!/bin/bash
#Publish & update vagrant metadata

export BOX_NAME=noble64
METADATA_DIR=/hdd/jenkins/workspace/vagrant/phz-vagrant-metadata

#Publish
test -e $WORKSPACE/results/$BOX_NAME.box && mv $WORKSPACE/results/$BOX_NAME.box $WORKSPACE/results/$BOX_NAME-$BUILD_NUMBER.box || exit 2

echo "Adding metadata"
SHA=`sha1sum /hdd/web/box/phz/$BOX_NAME-$BUILD_NUMBER.box |cut -d " " -f 1`

USERNAME=$VAGRANT_CLOUD_USERNAME
ACCESS_TOKEN=$VAGRANT_CLOUD_PASSWORD
curl "https://atlas.hashicorp.com/api/v1/box/$USERNAME/$BOX_NAME/version/$BUILD_NUMBER/provider/virtualbox/upload?access_token=$ACCESS_TOKEN"
