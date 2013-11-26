#!/bin/sh
ps -ef | grep "server.py" | awk '{print $2}' | xargs kill -KILL