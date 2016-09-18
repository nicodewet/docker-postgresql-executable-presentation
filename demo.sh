#!/usr/bin/env bash


printf "======================================\n"
printf "    Docker PostgreSQL Demo on Linux   \n"
printf "    - an executable presentation      \n"
printf "                                      \n"
printf "    created by: Nico de Wet           \n"
printf "======================================\n"
date

# Pauses set by trial and error
SHORT_PAUSE=10
PAUSE=30

function countdown(){
    echo ""
    local now=$(date +%s)
    local end=$((now + $1))
    while (( now < end )); do
        # BSD date invocation
        # printf "%s\r" "$(date -u -j -f %s $((end - now)) +%T)"
        # GNU date invocation
        printf "%s\r" "$(date -u -d @$((end - now)) +%T)"
        sleep 0.25
        now=$(date +%s)
    done
    echo
}

countdown $SHORT_PAUSE

printf "    AGENDA\n"
printf "        1. Setup checks\n"
printf "        2. Run Docker Hub official postgres repository image instructions\n"
printf "            2.1. Look at the Docker Hub postres OFFICIAL REPOSITORY web page\n"
printf "            2.2. Open a Homebrew terminal tab and run $ docker events\n"
printf "            2.2. Run Docker Hub official postgres image\n"
printf "            2.3. Run some network isolation sanity checks on the bridged container\n"
printf "            2.4. Break down the psql client command from the official instructions\n"
printf "            2.5. Run psql client command from the official instructions\n"
printf "        3. Backup the default postgres database\n"
printf "            3.1. Create new postgres container, and this time with a bind mount volume\n"
printf "            3.1. Do a backup using pg_dump in the running container to local filesystem\n"
printf "            3.2. Cleanup, remove container\n"
printf "        4. Build our own postgres image that will log each query\n"
printf "            4.1. Create a Dockerfile, config.sh and then build and run a container\n"
printf "            4.2. Execute a simple query then check the container logs\n"
printf "            4.3. Cleanup, remove container\n"

countdown $PAUSE

printf "\n	SETUP: is Docker Engine running? Lets try to talk to the Docker Engine with: $ docker info\n"

countdown $PAUSE

SUCCESS=0
FAILURE=1

printf "==============\n"
printf "$ docker info \n"
printf "==============\n"
docker info

if [ $? -ne $SUCCESS ]; then
    printf "\n	DEMO over: now is a good time to start Docker Engine.\n"
    exit $FAILURE
fi

printf "\n  SETUP: remove some-postgres container\n"

printf "============================\n"
printf "$ docker rm -v some-postgres \n"
printf "============================\n"
docker rm -v some-postgres

countdown $PAUSE

printf "\n  SETUP: what postgresql images do we have locally? Lets check with: $ docker images | grep postgres\n\n"

printf "================================\n"
printf "$ docker images | grep postgres \n"
printf "================================\n"
docker images | grep postgres

countdown $PAUSE

printf "\n  OFFICIAL instructions STEP 1: start a postgres instance\n"
printf "    We'll run $ docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres \n"
printf "    We'll effectively be running a bridged container (default network isolation mode) and will make this clear by running:\n $ docker run --name some-postgres --net bridge -e POSTGRES_PASSWORD=mysecretpassword -d postgres \n"

countdown $PAUSE

printf "====================================================================================\n"
printf "$ docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres \n"
printf "====================================================================================\n"
docker run --name some-postgres --net bridge -e POSTGRES_PASSWORD=mysecretpassword -d postgres

countdown $PAUSE
printf "    Check running containers with: $ docker ps\n"
printf "========================================================================\n"
printf "$ docker ps \n"
printf "========================================================================\n"
docker ps

countdown $PAUSE
printf "    The official instructions state the following: \n"
printf "    > This image includes EXPOSE 5432 (the postgres port), so standard container linking will make it automatically available to the linked containers. The default postgres user and database are created in the entrypoint with initdb.\n"

countdown $PAUSE
printf "    Lets put that to the test OLD SCHOOL. That is, WITHOUT using links for local service discovery and using port scanning with:\n $ docker run -it --rm dockerinaction/ch5_nmap -sS -p 5432 172.17.0.0/24\n"
printf "========================================================================\n"
printf "$ docker run -it --rm dockerinaction/ch5_nmap -sS -p 5432 172.17.0.0/24 \n"
printf "========================================================================\n"
docker run -it --rm dockerinaction/ch5_nmap -sS -p 5432 172.17.0.0/24

countdown $PAUSE
printf "    Let's sanity check our network configuration by listing the container interfaces with: $ docker exec some-postgres ip addr\n"
printf "    We expect to see that the container has joined the docker bridge network and so at least a bridge interface and a loopback interface\n\n"

printf "========================================================================\n"
printf "$ docker exec some-postgres ip addr \n"
printf "========================================================================\n"
docker exec some-postgres ip addr

countdown $PAUSE
printf "\n  OFFICIAL instructions STEP 2: connect to our running postgresql server using container wrapped psql\n"
printf "    This is the command: $ docker run -it --rm --link some-postgres:postgres postgres psql -h postgres -U postgres\n"
countdown $SHORT_PAUSE
printf "    Let's break that down.\n"
countdown $SHORT_PAUSE
printf " $ docker run -it ... postgres psql -h postgres -U postgres\n"
countdown $SHORT_PAUSE
printf " ==> Run the latest docker hub postgres image with an interactive terminal (-it) and execute the psql command with the specified host and username\n"
countdown $SHORT_PAUSE
printf " $ docker run ... --rm\n"
printf " ==> Delete the container when the command is done, we don't want it lingering around when we execute $ docker ps -a\n"
countdown $SHORT_PAUSE
printf " $ docker run ... --link some-postgres:postgres"
countdown $SHORT_PAUSE
printf " ==> We are effectively specifying an inter-container dependency. We are creating a link with alias set to <postgres>. <some-postgres> is the named target of the link that we assume is a running container.\n"    
countdown $SHORT_PAUSE
printf " ==> Links are meant to be used for local service discovery.\n"
countdown $SHORT_PAUSE
printf " ==> Huh?\n"
countdown $SHORT_PAUSE
printf " ==> We need local service discovery because containers have dynamic assigned IPs which they lose when they stop running.\n"
countdown $SHORT_PAUSE
printf " ==> Adding a link on a new container results in the following being done: \n"
printf " ==> 1. Environment variable describing the target container's end point created\n"
printf " ==> 2. The link alias added to the DNS override list of the new container with the IP address of the target container\n"
printf " ==> 3. If inter-container communication is disabled in the docker engine configuration, specific firewall rules added to allow communication between linked containers\n"

countdown $SHORT_PAUSE
printf "=====================================================================================================================================\n"
printf "$ docker run -e PGPASSWORD="mysecretpassword" --rm --link some-postgres:postgres postgres psql -h postgres -U postgres -c 'SELECT 1' \n"
printf "=====================================================================================================================================\n"
docker run -e PGPASSWORD="mysecretpassword" --rm --link some-postgres:postgres postgres psql -h postgres -U postgres -c 'SELECT 1'

countdown $PAUSE
printf "\n OFFICIAL instructions STEP 1: cleanup\n"

countdown $PAUSE
printf "============================\n"
printf "$ docker stop some-postgres \n"
printf "============================\n"
docker stop some-postgres

countdown $PAUSE

printf "============================\n"
printf "$ docker rm -v some-postgres \n"
printf "============================\n"
docker rm -v some-postgres

countdown $PAUSE
printf "============\n"
printf "$ docker ps \n"
printf "============\n"
printf "$ docker ps \n"
docker ps

countdown $PAUSE

printf "==============================================================================================================================\n"
printf " 3. Backup the default postgres database"
printf "$ docker run -v /ubuntu_data/backups/:/backups  --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres \n"
printf "$ docker inspect -f \"{{json .Mounts}}\" some-postgres \n"
printf "$ docker exec some-postgres pg_dump -w -U postgres postgres -f /backups/outfile \n"
printf "==============================================================================================================================\n"

countdown $PAUSE

docker run -v /ubuntu_data/backups/:/backups  --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
countdown $SHORT_PAUSE
docker inspect -f "{{json .Mounts}}" some-postgres
countdown 10
##
## The pg_dump command will fail when run from this script, but not when you run
## the sequence of 3 commands from the command line.
##

docker exec some-postgres pg_dump -w -U postgres postgres -f /backups/outfile -p 5432

printf "====================================\n"
printf "$ cat /ubuntu_data//backups/outfile \n"
printf "====================================\n"

cat /ubuntu_data/backups/outfile
countdown $SHORT_PAUSE

printf "============================\n"
printf "$ docker stop some-postgres \n"
printf "============================\n"
docker stop some-postgres

countdown SHORT_PAUSE

printf "============================\n"
printf "$ docker rm some-postgres \n"
printf "============================\n"
docker rm some-postgres

countdown SHORT_PAUSE

printf "========================================================\n"
printf "4. Build our own postgres image that will log each query\n"
printf "$ docker build . -t logo-postgres \n"
printf "========================================================\n"
docker build . -t logopostgres

countdown SHORT_PAUSE

printf "What did we just build?"

countdown SHORT_PAUSE

printf "==============================\n"
printf "$ cat /ubuntu_data/Dockerfile \n"
printf "==============================\n"

cat /ubuntu_data/Dockerfile
countdown $SHORT_PAUSE

printf "=============================\n"
printf "$ cat /ubuntu_data/config.sh \n"
printf "=============================\n"

cat /ubuntu_data/config.sh
countdown $SHORT_PAUSE

printf "===================================================================================================================================\n"
printf "$ docker run --name some-logo--postgres -e POSTGRES_PASSWORD=mysecretpassword -d -v /etc/localtime:/etc/localtime:ro logo-postgres \n"
printf "===================================================================================================================================\n"

countdown $SHORT_PAUSE
docker run --name some-logo-postgres -e POSTGRES_PASSWORD=mysecretpassword -d -v /etc/localtime:/etc/localtime:ro logopostgres

printf "=========================================================================================================================================================\n"
printf "$ docker run -e PGPASSWORD="mysecretpassword" --rm --link some-logo-postgres:postgres postgres psql -h postgres -U postgres -c 'SELECT 1'                \n"
printf "$ docker run -e PGPASSWORD="mysecretpassword" --rm --link some-logo-postgres:postgres postgres psql -h postgres -U postgres -c 'SELECT CURRENT_TIMESTAMP'  \n"
printf "$ docker logs some-logo-postgres \n"
printf "=========================================================================================================================================================\n"

countdown 10
docker run -e PGPASSWORD="mysecretpassword" --rm --link some-logo-postgres:postgres postgres psql -h postgres -U postgres -c 'SELECT 1'
docker run -e PGPASSWORD="mysecretpassword" --rm --link some-logo-postgres:postgres postgres psql -h postgres -U postgres -c 'SELECT CURRENT_TIMESTAMP'
docker logs some-logo-postgres

printf "============================\n"
printf "$ docker stop some-logo-postgres \n"
printf "============================\n"

docker stop some-logo-postgres

printf "============================\n"
printf "$ docker rm some-logo-postgres \n"
printf "============================\n"

docker rm some-logo-postgres
