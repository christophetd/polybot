#!/bin/bash

# This script is to be run on the production server to update the
# version of the bot
git reset --hard HEAD
git pull github master
pm2 delete all
pm2 kill
pm2 start `pwd`/../app.json
