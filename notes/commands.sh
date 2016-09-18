docker build . -t foosql
# Use a bind mount volume. Bind mount volumes are useful if you want to share data with other processes running
# outside a container, such as components of the host system itself.
# The bind mount volume mapping is delimited with a colon. The map key (the path before the colon) is 
# the absolute path of a location on the host file system, and the value (the path after the colon) is
# the location where it should be mounted inside the container. Locations must be specified with absolute paths.
docker run -d -p 5432:5432 -v /Users/nico/git/psql/data:/var/lib/postgresql/data --name foosql foosql
docker run -it --rm postgres:9.5.4 psql -h 192.168.1.6 -d mydb -U docker

# Use a docker-managed volume. Using docker-managed volumes is a method of decoupling volumes from specialized
# locations on the file system.
# Managed volumes are created when you use the -v option (--volume) on docker run but only specify the mount point
# in the container directory tree. With a docker-managed volume the docker daemon creates directories to store the 
# contents of specified volumes somewhere in a part of the host file system that it controls.
docker run -d -p 5432:5432 -v /var/lib/postgresql/data --name barsql foosql
docker inspect -f "{{json .Mounts}}" barsql
docker inspect barsql
# Note that with docker for mac the host path specified in each value is relative to the virtual
# machine root file system and not the root of the host.
