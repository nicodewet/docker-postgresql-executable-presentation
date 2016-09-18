# docker-postgresql-executable-presentation
An executable docker postgresql demo - entirely driven by a bash script.

## Setup

These are the steps you need to follow to ultimately get the demo.sh script running on your local machine using [vagrant](https://www.vagrantup.com).

1. Clone this repo.
2. Install [vagrant](https://www.vagrantup.com/docs/getting-started/) and its dependencies (e.g. [virtualbox](https://www.virtualbox.org/wiki/Linux_Downloads)).
3. In the directory where you cloned this repo, run *vagrant up* from a terminal, e.g. $ vagrant up.
4. Ssh into your VM by running *vagrant ssh* from a terminal, e.g. $ vagrant ssh
5. Install Docker Engine on your VM by following the Ubuntu Xenial 16.04 (LTS) section of the [Ubuntu Linux Docker Engine installation page](https://docs.docker.com/engine/installation/linux/ubuntulinux/).
