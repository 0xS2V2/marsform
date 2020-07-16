#!/bin/bash
find ./modules -type f -name global.tf -exec ln -sf ../../global.tf {} \;
