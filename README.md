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
* [Vagrant Version 1.8.1](https://www.vagrantup.com/downloads.html)


My Results
=============

| Distro/App   | Changes appear on file change | Changes appear on container restart |
|--------------|-------------------------------|-------------------------------------|
| Alpine/Flask | Yes (causes an error)         | Yes                                 |
| Alpine/Nginx | Yes                           | Yes                                 |
| Debian/Flask | Yes                           | Yes                                 |
| Debian/Nginx | Yes                           | Yes                                 |

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
