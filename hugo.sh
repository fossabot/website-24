#!/usr/bin/env bash

HUGO_VERSION="0.91.2"
HUGO_DESTINATION="public"
HUGO_DEBUG="" #--debug

wget https://github.com/gohugoio/hugo/releases/download/v$HUGO_VERSION/hugo_extended_"$HUGO_VERSION"_Linux-64bit.tar.gz
tar xvf hugo_extended_"$HUGO_VERSION"_Linux-64bit.tar.gz
chmod +x ./hugo
./hugo --gc --minify --destination "${HUGO_DESTINATION}" "${HUGO_DEBUG}"

#clever create --type static-apache website
clever scale --flavor nano
#clever domain add clever-cloud.com/fr/podcast
clever config set force-https enabled
clever env set CC_PRE_BUILD_HOOK "./hugo.sh"
#clever env set CC_PRE_BUILD_HOOK "${BASH_SOURCE[0]}"
#clever env set CC_WEBROOT "/${HUGO_DESTINATION}"
clever env set CC_WEBROOT "/public"
clever env set HUGO_ENV "production"
clever env set HUGO_VERSION "${HUGO_VERSION}"
clever env set PORT "1313"
clever link website
clever deploy

# https://www.clever-cloud.com/blog/engineering/2020/06/18/deploy-static-site-hugo/
# https://www.clever-cloud.com/doc/deploy/application/golang/go/
# https://hub.docker.com/r/klakegg/hugo/