sudo docker build -t lukather_db .

sudo docker run --rm -P --name pg_test eg_postgresql

sudo docker run --rm -t -i --link pg_test:pg lukather_db bash

psql -h $PG_PORT_5432_TCP_ADDR -p $PG_PORT_5432_TCP_PORT -d docker -U docker --password


