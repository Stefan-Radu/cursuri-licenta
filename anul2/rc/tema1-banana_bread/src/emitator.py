''' emitator Reliable UDP '''

import socket
import logging
import random
import time
import traceback

from argparse import ArgumentParser
from collections import deque
from copy import deepcopy
from helper import *


logging.basicConfig(format = u'[LINE:%(lineno)d]# %(levelname)-8s [%(asctime)s]\
                    %(message)s', level = logging.NOTSET)


def connect(adresa_receptor):
    '''
    Functie care initializeaza conexiunea cu receptorul.
    Returneaza ack_nr de la receptor si window
    '''

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, proto=socket.IPPROTO_UDP)
    # setam timeout pe socket in cazul in care
    # recvfrom nu primeste nimic intr-un interval de timp
    sock.settimeout(get_adaptive_timeout())

    # seq number e random, flag S de start,
    # checksum initial 0, payloadul nu exista
    seq_nr = random.randint(0, MAX_UINT32)
    flags = 'S'
    checksum = 0

    bytes_no_checksum = create_header_emitator(seq_nr, checksum, flags)
    checksum = calculeaza_checksum(bytes_no_checksum)
    mesaj = create_header_emitator(seq_nr ,checksum, flags)

    # trimit pana primesc raspuns de la server inapoi
    received = False
    start_time = stop_time = 0
    while not received:
        try:
            start_time = time.perf_counter()
            sock.sendto(mesaj, adresa_receptor)
            logging.info("Am trimis connect catre server...")

            data, _ = sock.recvfrom(MAX_SEGMENT)
            stop_time = time.perf_counter()
            if verifica_checksum(data) is False:
                logging.warning("Primit ack, dar e rau :(")
                continue

            received = True
            logging.info("Am primit raspuns! :D")
        except socket.timeout:
            logging.warning("Timeout la connect, retrying...")


    # parsez ce am primit de la server si returnez
    ack_nr, checksum, window = parse_header_receptor(data)

    assert ack_nr == seq_nr + 1

    logging.info('Ack Nr: "%d"', ack_nr)
    logging.info('Checksum: "%d"', checksum)
    logging.info('Window: "%d"', window)

    # update timeout
    update_adaptive_timeout(stop_time - start_time)
    sock.close()

    return ack_nr, window


def finalize(adresa_receptor, seq_nr, file_name):
    '''
    Functie care trimite mesajul de finalizare
    cu seq_nr dat ca parametru.
    '''

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, proto=socket.IPPROTO_UDP)
    # setam timeout pe socket in cazul in care
    # recvfrom nu primeste nimic intr-un interval de timp
    sock.settimeout(get_adaptive_timeout())

    seq_nr += 1
    flags = 'F'
    checksum = 0

    bytes_no_checksum = create_header_emitator(seq_nr, checksum, flags)
    mesaj = bytes_no_checksum + file_name.encode('utf-8')
    checksum = calculeaza_checksum(mesaj)

    bytes_with_checksum = create_header_emitator(seq_nr, checksum, flags)
    mesaj = bytes_with_checksum + file_name.encode('utf-8')

    # trimit pana primesc raspuns de la server inapoi
    data = None
    start_time = stop_time = 0

    try:
        start_time = time.perf_counter()
        sock.sendto(mesaj, adresa_receptor)
        logging.info("Am trimis finish catre server...")
        data, _ = sock.recvfrom(MAX_SEGMENT)
        stop_time = time.perf_counter()
        logging.info("Am primit raspuns! :D")
    except socket.timeout:
        logging.warning("Timeout la connect, retrying...")

    if data and verifica_checksum(data) is False:
        #daca checksum nu e ok, mesajul de la receptor trebuie ignorat
        logging.warning('Bad ack checksum in finalize.')

    # parsez ce am primit de la server si returnez
    ack_nr, checksum, window = parse_header_receptor(data)

    logging.info('Ack Nr: "%d"', ack_nr)
    logging.info('Checksum: "%d"', checksum)
    logging.info('Window: "%d"', window)

    # update timeout
    update_adaptive_timeout(stop_time - start_time)
    sock.close()

    return 0


send_lock = Lock()
recv_lock = Lock()
active_threads_lock = Lock()

def send(adresa_receptor, s_nr, segment, active_threads):
    '''
    Functie care trimite octeti ca payload catre receptor
    cu seq_nr dat ca parametru.
    Returneaza ack_nr si window curent primit de la server.
    '''

    seq_nr = deepcopy(s_nr)

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, proto=socket.IPPROTO_UDP)
    # setam timeout pe socket in cazul in care
    # recvfrom nu primeste nimic intr-un interval de timp
    sock.settimeout(get_adaptive_timeout())

    # flag de trimitere P, compun mesajul
    flags = 'P'
    checksum = 0

    # header with checksum 0
    header_bytes_no_checksum = create_header_emitator(seq_nr, checksum, flags)
    mesaj = header_bytes_no_checksum + segment

    # get checksum and repack header
    checksum = calculeaza_checksum(mesaj)
    header_bytes_with_checksum = create_header_emitator(seq_nr, checksum, flags)

    # final package
    mesaj = header_bytes_with_checksum + segment

    received = False
    start_time = stop_time = 0
    while not received:
        try:

            send_lock.acquire()
            sock.sendto(mesaj, adresa_receptor)
            send_lock.release()

            logging.info("Am trimis pachet catre server...")

            recv_lock.acquire()
            start_time = time.perf_counter()
            data, _ = sock.recvfrom(MAX_SEGMENT)
            stop_time = time.perf_counter()
            recv_lock.release()

            if verifica_checksum(data) is False:
                logging.warning("Primit ack, dar e rau :(")
                continue

            received = True
            logging.info("Primit ack, si e bun :D")
        except socket.timeout:
            if recv_lock.locked():
                recv_lock.release()
            logging.warning("Timeout la trimitere, retrying...")


    logging.info("Trimis cu succes!")
    ack_nr, checksum, window = parse_header_receptor(data)

    assert ack_nr == seq_nr

    logging.info('Ack Nr: "%d"', ack_nr)
    logging.info('Checksum: "%d"', checksum)
    logging.info('Window: "%d"\n', window)

    # update timeout
    update_adaptive_timeout(stop_time - start_time)
    sock.close()

    # mark as done
    active_threads_lock.acquire()
    assert seq_nr in active_threads
    thread, _ = active_threads[seq_nr]
    active_threads[seq_nr] = (thread, 'done')
    active_threads_lock.release()

    return ack_nr, window


def main():
    parser = ArgumentParser(usage=__file__ + ' '
                                             '-a/--adresa IP '
                                             '-p/--port PORT'
                                             '-f/--fisier FILE_PATH',
                            description='Reliable UDP Emitter')

    parser.add_argument('-a', '--adresa',
                        dest='adresa',
                        default='receptor',
                        help='Adresa IP a receptorului (IP-ul containerului, ' \
                             'localhost sau altceva)')

    parser.add_argument('-p', '--port',
                        dest='port',
                        default='10000',
                        help='Portul pe care asculta receptorul pentru mesaje')

    parser.add_argument('-f', '--fisier',
                        dest='fisier',
                        help='Calea catre fisierul care urmeaza a fi trimis')

    # Parse arguments
    args = vars(parser.parse_args())

    ip_receptor = args['adresa']
    port_receptor = args['port']
    fisier = args['fisier']

    adresa_receptor = (ip_receptor, int(port_receptor))

    send_lock = Lock()
    max_window_size = 1
    active_threads = {}
    current_window = deque()

    try:
        # ma conectez la server si primesc ack si window-ul
        seq_nr, window = connect(adresa_receptor)

        file_descriptor = open(fisier, 'rb')

        # sliding window
        segment_generator = citeste_segment(file_descriptor)
        while True:
            try:
                # handle finished threads and slide window
                while len(current_window) != 0:
                    active_threads_lock.acquire()
                    thread, status = active_threads.get(current_window[0])
                    active_threads_lock.release()
                    if status == 'in_progress':
                        break

                    # left-most package set successfully
                    assert status == 'done'
                    # join thread
                    _, window = thread.join()

                    if window == 0:
                        # full buffer. stop
                        break

                    max_window_size = window
                    # update thread manager
                    active_threads_lock.acquire()
                    del active_threads[current_window[0]]
                    active_threads_lock.release()
                    current_window.popleft()

                # send new packages
                while len(current_window) < max_window_size:
                    # get next segment
                    segment = next(segment_generator)
                    # create new thread
                    thread = ThreadWithReturn(target=send, args=(adresa_receptor, \
                            deepcopy(seq_nr), segment, active_threads))
                    # add in manager
                    current_window.append(seq_nr)
                    active_threads_lock.acquire()
                    active_threads[seq_nr] = (thread, 'in_progress')
                    active_threads_lock.release()
                    # start thread
                    thread.start()
                    # set next seq number
                    seq_nr = (seq_nr + len(segment)) % MAX_UINT32

            except StopIteration:
                # read all segments
                for thread, _ in active_threads.values():
                    thread.join()
                break

        # inchis conexiunea
        finalize(adresa_receptor, seq_nr, fisier)

    except Exception as e:
        logging.error(e)
        traceback.print_exc()
        file_descriptor.close()


if __name__ == '__main__':
    main()
