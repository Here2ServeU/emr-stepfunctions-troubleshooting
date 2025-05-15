#!/bin/bash
sudo yum update -y
sudo pip install boto3

# Tune Spark config
echo 'spark.executor.memory=2g' >> /etc/spark/conf/spark-defaults.conf
echo 'spark.driver.memory=1g' >> /etc/spark/conf/spark-defaults.conf
