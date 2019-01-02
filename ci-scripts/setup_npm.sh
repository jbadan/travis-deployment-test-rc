#!/bin/bash

set -o nounset
set -o errexit

npm whoami

npm login <<!
${NPM_USERNAME}
${NPM_PASSWORD}
${NPM_EMAIL}
!

npm whoami