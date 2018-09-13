#!/bin/bash
aws s3 --region us-east-1 cp s3://miller-minecraft-backup/world/$1 world.tar.gz
if [ -d "/home/ubuntu/world" ]
then
        sudo rm -r /home/ubuntu/world
fi
tar -zxf world.tar.gz
rm /home/ubuntu/world.tar.gz