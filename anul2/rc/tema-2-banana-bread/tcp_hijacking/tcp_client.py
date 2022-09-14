# TCP client

import socket
import logging
import time
from random import choice


logging.basicConfig(format = u'[LINE:%(lineno)d]# %(levelname)-8s'
                    ' [%(asctime)s]  %(message)s', level = logging.NOTSET)

# colectie de mesaje aleatoare
mesaje = [b'cartof', b'restaurant', b'perceive', b'obese', b'paper',
          b'reluctance', b'remark', b'negotiation', b'excavate',
          b'appendix', b'hospitality', b'inside', b'secretion',
          b'vehicle', b'costume', b'express', b'length', b'isolation',
          b'hunter', b'interference', b'chord', b'movement',
          b'occupation', b'serious', b'unanimous', b'ash',
          b'censorship', b'crystal', b'tough', b'coma',
          b'miscarriage', b'clay', b'find', b'voyage',
          b'channel', b'roll', b'brush', b'slide', b'claim', b'screw',
          b'chop', b'strategic', b'eject', b'ministry', b'investigation',
          b'participate', b'private', b'bathtub', b'amputate']


sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM, \
                     proto=socket.IPPROTO_TCP)

port = 10000
adresa = '198.10.0.2'
server_address = (adresa, port)

try:
    # initializez conectiune
    logging.info('Handshake cu %s', str(server_address))
    sock.connect(server_address)

    while True:
        # trimit mesaj aleator si astept raspuns
        to_send = choice(mesaje)
        logging.info('Clientul trimite: %s', to_send)
        sock.send(to_send)
        data = sock.recv(1024)
        logging.info('Clientul primeste: %s', data)
        time.sleep(1)

except KeyboardInterrupt:
    logging.info('closing socket')
    sock.close()
