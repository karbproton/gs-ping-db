# https://docs.docker.com/language/golang/build-images/

## Rest Server & DB
- Run & Config DB
- Build Rest Server Image & Run

> docker build --tag gs-ping-db .

# Tag Image - Example: docker image tag docker-gs-ping:latest docker-gs-ping:v1.0

# Run DB (pre: Volume & Network)
> docker volume list    / docker volume create roach
> docker network list   / docker network create -d bridge mynet

docker run -d \
  --name roach \
  --hostname db \
  --network mynet \
  -p 26257:26257 \
  -p 8080:8080 \
  -v roach:/cockroach/cockroach-data \
  cockroachdb/cockroach:latest-v20.1 start-single-node \
  --insecure

  ## Config DB
  > docker exec -it roach ./cockroach sql --insecure
  defaultdb> CREATE DATABASE mydb;
  defaultdb> CREATE USER totoro;
  defaultdb> GRANT ALL ON DATABASE mydb TO totoro;
  defaultdb> quit

  # Run Rest Server -> DB
  docker run -it --rm -d \
  --network mynet \
  --name rest-server \
  -p 80:8080 \
  -e PGUSER=totoro \
  -e PGPASSWORD=myfriend \
  -e PGHOST=db \
  -e PGPORT=26257 \
  -e PGDATABASE=mydb \
  gs-ping-db

  ## TEST application
  curl --request POST \
  --url http://localhost/send \
  --header 'content-type: application/json' \
  --data '{"value": "Hello, Docker!"}'

# SHUT down rest-server & db
> docker container stop rest-server roach
> docker container rm rest-server roach






