OUTPUT_FILE=/elocal/output
RECEPTOR_IP=198.8.0.2
START_FILE=/elocal/start.png

up:
	docker-compose up -d
	
runre:
	docker-compose exec receptor bash -c 'python3 /elocal/src/receptor.py -p 10000 -f $(OUTPUT_FILE)'

runem:
	docker-compose exec emitator bash -c 'python3 /elocal/src/emitator.py -a $(RECEPTOR_IP) -p 10000 -f $(START_FILE)'
