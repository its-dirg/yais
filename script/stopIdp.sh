#!/bin/sh
ps -ef | grep "idp.py" | awk '{print $2}' | xargs kill