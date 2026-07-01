#!/bin/bash

THIS_DIR=$(dirname $(realpath $0))

node "${THIS_DIR}"/gren-format/app "$@"
