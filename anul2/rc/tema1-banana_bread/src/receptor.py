''' receptor Reiable UDP '''

import socket
import logging
import random
import subprocess

from argparse import ArgumentParser
from queue import Queue
from helper import *


logging.basicConfig(format = u'[LINE:%(lineno)d]# %(levelname)-8s [%(asctime)s]\
                    %(message)s', level = logging.NOTSET)


def check_identical(fisier1, fisier2):
    with open('/dev/null', 'w') as out: # into the trash it goes
        result = subprocess.run(['diff', '-s', fisier1, fisier2], stdout=out)
        return_code = result.returncode

    if return_code == 0:
        return True
    return False



def main():
    parser = ArgumentParser(usage=__file__ + ' '
                                             '-p/--port PORT'
                                             '-f/--fisier FILE_PATH',
                            description='Reliable UDP Receptor')

    parser.add_argument('-p', '--port',
                        dest='port',
                        default='10000',
                        help='Portul pe care sa porneasca receptorul pentru a primi mesaje')

    parser.add_argument('-f', '--fisier',
                        dest='fisier',
                        default='output',
                        help='Calea catre fisierul in care se vor scrie octetii primiti')

    # Parse arguments
    args = vars(parser.parse_args())
    port = int(args['port'])
    fisier = args['fisier']

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, proto=socket.IPPROTO_UDP)

    destination_file = open(fisier, "wb")

    adresa = '0.0.0.0'
    server_address = (adresa, port)
    sock.bind(server_address)
    logging.info("Serverul a pornit pe %s si portul %d", adresa, port)

    ack_nr_details = {}
    current_window = Queue()
    MAX_PACKET_HOLD = 27
    next_ack_nr = None

    while True:
        logging.info('Asteptam mesaje...')
        # header size + max segment
        data, address = sock.recvfrom(MAX_SEGMENT + 8)

        # verific checksum
        if verifica_checksum(data) is False:
            logging.warning('Bad cksum. Packet discarded.')
            continue # discard pachet

        # separ content de header
        header = data[:8]
        payload = data[8:]
        # print("am primit", parse_header_emitator(header), len(data))

        # checksum ok => compun raspuns in fct de tip mesaj
        seq_nr, checksum, flag = parse_header_emitator(header)

        if flag in ('S', 'F'):
            ack_nr = (seq_nr + 1) % MAX_UINT32
            if next_ack_nr is None:
                next_ack_nr = ack_nr
        else: # daca e P
            ack_nr = seq_nr

        checksum = 0
        window = random.randint(1, 5)

        bytes_no_checksum = struct.pack('!LHH', ack_nr, checksum, window)

        checksum = calculeaza_checksum(bytes_no_checksum)
        bytes_with_checksum = struct.pack('!LHH', ack_nr, checksum, window)

        sock.sendto(bytes_with_checksum, address)

        if flag == 'S':
            # nothing left to do on connect
            continue

        # write to file
        while next_ack_nr in ack_nr_details:
            status, payload_pe_care_vreau_sa_il_scriu_nu_payload_ala_de_mai_sus_ca_am_avut_bug = ack_nr_details[next_ack_nr]
            assert status == 'to_be_written'

            destination_file.write(payload_pe_care_vreau_sa_il_scriu_nu_payload_ala_de_mai_sus_ca_am_avut_bug)
            logging.info('%s ...', payload[:27])
            ack_nr_details[next_ack_nr] = ('done', '')

            # update next_ack
            next_ack_nr = (next_ack_nr + len(payload_pe_care_vreau_sa_il_scriu_nu_payload_ala_de_mai_sus_ca_am_avut_bug)) % MAX_UINT32

        if flag == 'F':
            file_name = payload.decode('utf-8')

            logging.info("Fisier gata! Pa-pa!")
            destination_file.close()

            # la tipul F trimit numele fisierului din
            # emitator ca sa pot sa compar intre ele
            # dat fiind ca sunt pe acelasi shared volume
            if check_identical(fisier, file_name):
                logging.info("Fisierele sunt identice!")
            else:
                logging.error("Fisierele nu sunt identice! :(")

            break

        if ack_nr in ack_nr_details:
            logging.info('Resent package. No further action.')
            continue

        # register package
        assert ack_nr not in ack_nr_details
        ack_nr_details[ack_nr] = ('to_be_written', payload)
        current_window.put(ack_nr)
        if current_window.qsize() > MAX_PACKET_HOLD:
            oldest = current_window.get()
            ack_nr_details.pop(oldest)


if __name__ == '__main__':
    main()
