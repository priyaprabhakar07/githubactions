#!/bin/bash

set -x
echo "execeuting"
cd ./http-echo
make clean dist bin docker
