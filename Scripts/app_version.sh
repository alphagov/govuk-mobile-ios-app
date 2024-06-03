#!/bin/bash

xcodebuild -showBuildSettings | grep MARKETING_VERSION | tr -d 'MARKETING_VERSION ='
