# TCP Server
import socket
import logging
import time

logging.basicConfig(format = u'[LINE:%(lineno)d]# %(levelname)-8s' \
                    ' [%(asctime)s]  %(message)s', level = logging.NOTSET)

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM, \
                     proto=socket.IPPROTO_TCP)

port = 10000
adresa = '0.0.0.0'
server_address = (adresa, port)
sock.bind(server_address)

# initiez conectiunea
logging.info("Serverul a pornit pe %s si portnul portul %d", adresa, port)
sock.listen(1)
logging.info('Asteptam conexiuni...')
conexiune, address = sock.accept()
logging.info("Handshake cu %s", address)

try:
    while True:
        # receiving data and sending confirmatin data back
        data = conexiune.recv(1024)
        logging.info('Serverul primeste: %s', data)
        time.sleep(1)

except KeyboardInterrupt:
    conexiune.close()
    sock.close()
