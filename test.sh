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

vagrant destroy -f
NFS=$install_nfs vagrant up --no-provision

docker_ip="192.168.33.10"

# Spin up our containers
vagrant provision

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
sleep 3

# Verify changed conditions
echo "======> Checking for change w/out restart"
if [ "$install_nfs" = "1" ]; then
    result_message="Python Alpine: FAILED"
    curl -s http://$docker_ip:8000 | grep -q "CHANGED"
    check_result
fi

result_message="Python Slim: FAILED"
curl -s http://$docker_ip:8001 | grep -q "CHANGED"
check_result

result_message="Nginx Alpine: FAILED"
curl -s http://$docker_ip:8002 | grep -q "CHANGED"
check_result

result_message="Nginx Jessie: FAILED"
curl -s http://$docker_ip:8003 | grep -q "CHANGED"
check_result

echo "======> Restarting containers"
NFS=$install_nfs vagrant reload
docker start $(docker ps -aq)
sleep 3

echo "======> Checking for change with restart"
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
