RECEPTOR_IP=198.8.0.2
START_FILE=/elocal/start.png
COMPOSE_ARGS= -f ../containers/docker-compose.yml

start:
	docker-compose $(COMPOSE_ARGS) start

stop:
	docker-compose $(COMPOSE_ARGS) stop

down:
	docker-compose $(COMPOSE_ARGS) down

up:
	docker-compose $(COMPOSE_ARGS) up -d

runclient:
	docker-compose $(COMPOSE_ARGS) exec client bash -c 'python3 /elocal/tcp_hijacking/tcp_client.py'

runserver:
	docker-compose $(COMPOSE_ARGS) exec server bash -c 'python3 /elocal/tcp_hijacking/tcp_server.py'

runmiddle:
	docker-compose $(COMPOSE_ARGS) exec middle bash -c 'python3 /elocal/tcp_hijacking/intercepter.py'

runarp:
	docker-compose $(COMPOSE_ARGS) exec middle bash -c 'python3 /elocal/arp-spoofing/spoofer.py'

clean:
	docker network prune
	docker rm -f $$(docker ps -a -q)

rundump:
	docker-compose $(COMPOSE_ARGS) exec middle bash -c 'tcpdump -SntvXX -i any'

see:
	docker-compose $(COMPOSE_ARGS) exec server bash -c 'arp -a'
	docker-compose $(COMPOSE_ARGS) exec router bash -c 'arp -a'

cleanarp:
	docker-compose $(COMPOSE_ARGS) exec server bash -c 'ip -s -s neigh flush all' 
	docker-compose $(COMPOSE_ARGS) exec router bash -c 'ip -s -s neigh flush all' 
