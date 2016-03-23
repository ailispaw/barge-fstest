#!/bin/bash

MACHINE_NAME="fschangetest"
errors=0

if [ "$1" == "nfs" ]; then
    install_nfs=1
else
    install_nfs=0
fi

check_result() {
    if [ "$?" -ne "0" ]; then
        errors=1
        echo "======> $result_message"
    fi
}

exit_if_errors() {
    if [ "$errors" -ne "0" ]; then
        echo "======> $error_message"
        exit -1
    else
        errors=0
    fi
}

git checkout -- app.py index.html

# Set us up a clean docker-machine
if docker-machine ls | grep $MACHINE_NAME; then
    docker-machine stop $MACHINE_NAME
    docker-machine rm -f $MACHINE_NAME
    docker-machine create --driver=virtualbox $MACHINE_NAME
    if [ "$install_nfs" -eq 1 ]; then
        docker-machine-nfs $MACHINE_NAME
    fi
else
    docker-machine create --driver=virtualbox $MACHINE_NAME
fi

docker_ip=$(docker-machine ip $MACHINE_NAME)
eval $(docker-machine env $MACHINE_NAME)
docker-compose stop
docker-compose rm -f

# Spin up our containers
docker-compose build
docker-compose up -d

# Wait to ensure everythings up
sleep 3

# Verify starting conditions
curl -s http://$docker_ip:8000 | grep -q "STARTING-TEXT"
check_result

curl -s http://$docker_ip:8001 | grep -q "STARTING-TEXT"
check_result

curl -s http://$docker_ip:8002 | grep -q "STARTING-TEXT"
check_result

curl -s http://$docker_ip:8003 | grep -q "STARTING-TEXT"
check_result

error_message="STARTING-TEXT not found on one or more URLs"
exit_if_errors

# Change the text
sed -i.bak s/STARTING-TEXT/CHANGED/g index.html
sed -i.bak s/STARTING-TEXT/CHANGED/g app.py

grep -q "CHANGED" ./index.html
check_result

grep -q "CHANGED" ./app.py
check_result
error_message="CHANGED not found in source files"
exit_if_errors

# Wait for changes to be picked up
sleep 30

# Verify changed conditions
result_message="Python Alpine: FAILED"
curl -s http://$docker_ip:8000 | grep -q "CHANGED"
check_result

result_message="Python Slim: FAILED"
curl -s http://$docker_ip:8001 | grep -q "CHANGED"
check_result

result_message="Nginx Alpine: FAILED"
curl -s http://$docker_ip:8002 | grep -q "CHANGED"
check_result

result_message="Nginx Jessie: FAILED"
curl -s http://$docker_ip:8003 | grep -q "CHANGED"
check_result

error_message="CHANGED not found on one or more URLs"
exit_if_errors

echo "======> SUCCESS! NFS: $install_nfs"
