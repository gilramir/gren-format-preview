#!/bin/bash

THIS_DIR=$(dirname $(realpath $0))

# Add node to your path
#export PATH=/opt/nodejs/25.1.0/bin:$PATH

export GREN_BIN="${THIS_DIR}"/compiler/gren

node "${THIS_DIR}"/compiler/app "$@"
