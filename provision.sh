#!/bin/bash

sudo apt-get update
sudo apt-get install mongodb -y
sudo service mongodb stop

# http://stackoverflow.com/questions/19100708/mongodb-mongorestore-failure-localefacet-s-create-c-locale-name-not-valid
export LC_ALL="en_US.UTF-8"

# http://hachi.hatenablog.com/entry/2012/02/26/191349
mkdir -p ~/data/mongod1
mkdir -p ~/data/mongod2
mkdir -p ~/data/mongod3

mkdir -p ~/data/mongoc1
mkdir -p ~/data/mongoc2
mkdir -p ~/data/mongoc3

mkdir ~/log

mongod --shardsvr --dbpath ~/data/mongod1 --logpath ~/log/mongod1.log --port 27031 --fork
mongod --shardsvr --dbpath ~/data/mongod2 --logpath ~/log/mongod2.log --port 27032 --fork
mongod --shardsvr --dbpath ~/data/mongod3 --logpath ~/log/mongod3.log --port 27033 --fork

mongod --configsvr --dbpath ~/data/mongoc1 --logpath ~/log/mongoc1.log --port 27011 --fork
mongod --configsvr --dbpath ~/data/mongoc2 --logpath ~/log/mongoc2.log --port 27012 --fork
mongod --configsvr --dbpath ~/data/mongoc3 --logpath ~/log/mongoc3.log --port 27013 --fork

mongos --configdb localhost:27011,localhost:27012,localhost:27013 --logpath ~/log/mongos1.log --chunkSize 1 --port 27017 --fork

mongo admin --eval 'db.runCommand({"addShard":"localhost:27031"})'
mongo admin --eval 'db.runCommand({"addShard":"localhost:27032"})'
mongo admin --eval 'db.runCommand({"addShard":"localhost:27033"})'

mongo admin --eval 'db.adminCommand({"enableSharding":"circle_test"})'

mongo admin --eval 'db.adminCommand({"shardCollection":"circle_test.blogs"},"key":{"user_id":1})'

