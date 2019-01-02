#!/bin/bash

set -o nounset
set -o errexit

npm config set registry https://registry.npmjs.org/
npm login << !
${NPM_USERNAME}
${NPM_PASSWORD}
${NPM_EMAIL}
!