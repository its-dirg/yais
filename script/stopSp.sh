#!/bin/sh
ps -ef | grep "sp.py" | awk '{print $2}' | xargs kill -KILL