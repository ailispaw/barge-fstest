Files not changing on virtualbox instances?
=============================================================


Usage
--------
```
git clone https://github.com/ailispaw/docker-machine-fstest.git

cd docker-machine-fstest/

git checkout docker-root

# Run test with default volume mounting from virtualbox
bash ./test.sh

# Optionally test it with NFS
bash ./test.sh nfs
```

Requirements
---------------
* [Virtualbox Version 5.0.16 r105871](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)


My Results
=============

**Really weird results in bold**

| Distro/App   	| Changes appear on file change 	| Changes appear on container restart 	|
|--------------	|-------------------------------	|-------------------------------------	|
| Alpine/Flask 	| NO                            	| **NO**                              	|
| Alpine/Nginx 	| NO                            	| **NO**                              	|
| Debian/Flask 	| Yes                           	| Yes                                 	|
| Debian/Nginx 	| **NO**                        	| **NO**                              	|

```
# Without NFS
======> Checking for change w/out restart
======> Restarting containers
======> Checking for change with restart
======> SUCCESS! NFS: 0

# With NFS
======> Checking for change w/out restart
======> Restarting containers
======> Checking for change with restart
======> SUCCESS! NFS: 1
```
