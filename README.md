Files not changing on docker-machine virtualbox instances?
=============================================================

**[Potential bug I've encountered](https://github.com/docker/machine/issues/3222)**:

1. You've spun up a docker-machine VM using Virtualbox on OSX.

2. You've got a local app that you're doing local development with via docker-compose

3. You've got process that'll reload on changes to the files -- ./manage.py runserver, Flask's .run(debug=True), etc.

4. You make changes to files but they don't appear in the running container. Sometimes old content in the files continues to appear, even after a docker-compose stop/start.

Workaround
--------------

Using [docker-machine-nfs](https://github.com/adlogix/docker-machine-nfs) seems to fix the issue.


Usage
--------
```
git clone https://github.com/cmheisel/docker-machine-fstest.git

cd docker-machine-fstest/

# Run test with default volume mounting from virtualbox
bash ./test.sh

# Optionally test it with NFS
bash ./test.sh nfs
```

Requirements
---------------
* [OS X El Capitan](https://itunes.apple.com/us/app/os-x-el-capitan/id1018109117?mt=12)
* [Virtualbox Version 5.0.16 r105871](https://www.virtualbox.org/wiki/Downloads)
* [Docker version 1.10.3, build 20f81dd](https://docs.docker.com/engine/installation/mac/)
* [docker-compose version 1.6.2, build 4d72027](https://docs.docker.com/compose/)
* [docker-machine version 0.6.0, build e27fb87](https://docs.docker.com/machine/)
* [docker-machine-nfs](https://github.com/adlogix/docker-machine-nfs) Optional


My Results
=============
```
# Without NFS
======> Checking for change w/out restart
======> Python Alpine: FAILED
======> Nginx Alpine: FAILED
======> Nginx Jessie: FAILED
======> Restarting containers
======> Checking for change with restart
======> Python Alpine: FAILED
======> Nginx Alpine: FAILED
======> Nginx Jessie: FAILED
======> CHANGED not found on one or more URLs

# With NFS
======> SUCCESS! NFS: 1
```
