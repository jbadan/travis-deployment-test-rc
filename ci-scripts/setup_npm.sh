#!/bin/bash

set -o nounset
set -o errexit

npm login --registry=https://registry.npmjs.org/ << !
$NPM_USERNAME
$NPM_PASSWORD
$NPM_EMAIL
!