#!/bin/sh
ps -ef | grep "dirg_web_server.py" | awk '{print $2}' | xargs kill -KILL