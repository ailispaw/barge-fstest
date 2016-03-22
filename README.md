Files not changing on docker-machine virtualbox instances?
=============================================================

**Potential bug I've encountered**:
1. You've spun up a docker-machine VM using Virtualbox on OSX.
2. You've got a local app that you're doing local development with via docker-compose
3. You've got process that'll reload on changes to the files -- ./manage.py runserver, Flask's .run(debug=True), etc.
4. You make changes to files but they don't appear in the running container. Sometimes old content in the files continues to appear, even after a docker-compose stop/start.
