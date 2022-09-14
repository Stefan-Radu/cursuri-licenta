OUTPUT_FILE=/elocal/output
RECEPTOR_IP=198.8.0.2
START_FILE=/elocal/start.png
COMPOSE_ARGS= -f ../containers/docker-compose.yml

up:
	docker-compose $(COMPOSE_ARGS) up -d

down:
	docker-compose $(COMPOSE_ARGS) down

runarp:
	docker-compose $(COMPOSE_ARGS) exec middle bash -c 'python3 /elocal/arp-spoofing/spoofer.py'

clean:
	docker network prune
	docker rm -f $$(docker ps -a -q)

rundump:
	docker-compose $(COMPOSE_ARGS) exec middle bash -c 'tcpdump -SntvXX -i any'

runwget:
	docker-compose $(COMPOSE_ARGS) exec server bash -c 'wget http://old.fmi.unibuc.ro'

see:
	docker-compose $(COMPOSE_ARGS) exec server bash -c 'arp -a'
	docker-compose $(COMPOSE_ARGS) exec router bash -c 'arp -a'

cleanarp:
	docker-compose $(COMPOSE_ARGS) exec server bash -c 'ip -s -s neigh flush all' 
	docker-compose $(COMPOSE_ARGS) exec router bash -c 'ip -s -s neigh flush all' 