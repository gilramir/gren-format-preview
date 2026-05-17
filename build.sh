#!/bin/bash

set -e

cd compiler

devbox run prepare-deps
devbox run build
