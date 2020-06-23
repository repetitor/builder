#!/bin/bash

source /tmp/.env

cd $WORKSPACE

chown -R $CURRENT_USER_ID:$CURRENT_GROUP_ID $WORKSPACE
chown -R $WEBSERVER_USER storage
chown -R $WEBSERVER_USER bootstrap/cache
