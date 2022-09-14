import struct
import socket
import logging

from copy import deepcopy
from threading import Thread, Lock

MAX_UINT32 = 0xFFFFFFFF
# pe 16 biti / 2 octeti
MAX_UINT16 = 0xFFFF
MAX_SEGMENT = 1400

SRTT = 0
Svar = 0.25
TIMEOUT = 1
sto_lock = Lock()


class ThreadWithReturn(Thread):
    '''
    Thread that return target result on join
    '''
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._return = None

    def run(self):
        if self._target is not None:
            self._return = self._target(*self._args, **self._kwargs)

    def join(self, *args, **kwargs):
        super().join(*args, **kwargs)
        return self._return


def update_adaptive_timeout(RTT):
    global SRTT, Svar, TIMEOUT
    sto_lock.acquire()
    SRTT = 0.9*SRTT + 0.1*RTT
    Svar = 0.9*Svar + 0.1*abs(RTT - SRTT)
    TIMEOUT = SRTT + 4*Svar
    sto_lock.release()

def get_adaptive_timeout():
    sto_lock.acquire()
    ret = TIMEOUT
    sto_lock.release()
    return ret


def compara_endianness(numar):
    print ("Numarul: ", numar)
    print ("Network Order (Big Endian): ", [bin(byte) for byte in struct.pack('!H', numar)])
    print ("Little Endian: ", [bin(byte) for byte in struct.pack('<H', numar)])


def create_header_emitator(seq_nr, checksum, flags='S'):
    #spf = 0b000
    if flags == 'S':
        spf = 0b100
    elif flags == 'P':
        spf = 0b010
    elif flags == 'F':
        spf =0b001
    spf_zero = spf << 13
    octeti = struct.pack("!LHH", seq_nr, checksum, spf_zero)
    return bytes(octeti)


def parse_header_emitator(octeti):
    seq_nr, checksum, spf =  struct.unpack("!LHH", octeti)
    spf = spf >> 13
    flags = ''
    if spf & 0b100:
        # inseamna ca am primit S
        flags = 'S'
    elif spf & 0b001:
        # inseamna ca am primit F
        flags = 'F'
    elif spf & 0b010:
        # inseamna ca am primit P
        flags = 'P'
    return (seq_nr, checksum, flags)


def create_header_receptor(ack_nr, checksum, window):
    octeti = struct.pack("!LHH",ack_nr,checksum,window)
    return octeti


def parse_header_receptor(octeti):
    ack_nr, checksum, window = struct.unpack("!LHH",octeti)
    return (ack_nr, checksum, window)


def citeste_segment(file_descriptor):
    # generator, returneaza cate un segment de 1400 de octeti dintr-un fisier
    while seg := file_descriptor.read(MAX_SEGMENT):
        yield seg


def exemplu_citire(cale_catre_fisier):
    with open(cale_catre_fisier, 'rb') as file_in:
        for segment in citeste_segment(file_in):
            print(segment)


def calculeaza_checksum(octeti):
    # padding pentru lungime impara
    if (len(octeti) & 1):
      octeti += struct.pack('!B', 0)

    # extragere segmente
    segment_count = len(octeti) // 2
    segments = struct.unpack(f'!{segment_count}H', octeti)

    segment_sum = sum(map(int, segments))

    # insumare cu aduntul repetitiv a ce e extra
    while segment_sum > MAX_UINT16:
      limited = segment_sum & MAX_UINT16
      extra = segment_sum >> 16
      segment_sum = limited + extra

    # complementare
    checksum = MAX_UINT16 - segment_sum

    return checksum


def verifica_checksum(octeti):
    # daca e 0 e bine altfel e rau
    bytess = deepcopy(octeti)
    return calculeaza_checksum(bytess) == 0


if __name__ == '__main__':
    # header = create_header_emitator(15, 0, 'P')
    # print(header)
    # chksum = calculeaza_checksum(header)
    # print(chksum)
    # header = create_header_emitator(15, int(chksum), 'P')
    # print(header)
    # chksum = calculeaza_checksum(header)
    # print(chksum)
    # exemplu_citire("../test")
    pass
