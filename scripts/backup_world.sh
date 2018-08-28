#!/bin/bash
today=`date '+%d_%H-%M'`;
year=`date '+%Y'`;month=`date '+%m'`;
cd /home/ubuntu && \
tar -czvf world.tar.gz world && \
aws s3 --region us-east-2 cp world.tar.gz s3://ethan-miller-minecraft-backup/world/$year/$month/world_$today.tar.gz
rm world.tar.gz