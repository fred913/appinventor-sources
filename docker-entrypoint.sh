#!/bin/bash

java_dev_appserver.sh --port=8888 --address=0.0.0.0 appengine/build/war/ &

cd appinventor/buildserver
ant RunLocalBuildServer
