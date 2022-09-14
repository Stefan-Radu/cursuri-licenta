import os
import socket
import traceback
import requests

from config import X_RAPIDAPI_KEY, X_RAPIDAPI_HOST, MAX_HOPS
from random import randint
from sys import argv


def get_location_info(ip):
    '''Folositi un API public, cum ar fi cel de la ip2loc pentru
    a afisa locatia despre IP: https://ip2loc.com/documentation'''

    header = {
        "x-rapidapi-key": X_RAPIDAPI_KEY,
        "x-rapidapi-host": X_RAPIDAPI_HOST,
        "useQueryString": "true"
    }
    data = {
        "ip":ip
    }
    url = 'https://' + X_RAPIDAPI_HOST + '/json/'

    r = requests.get(url = url, params = data, headers = header)
    json = r.json()

    oras = json['city'] or 'N/A'
    regiune = json['region'] or 'N/A'
    tara = json['country'] or 'N/A'
    return oras, regiune, tara


def get_icmp_type(data):
    # extract header length
    ip_header_length = (data[0] & 15)
    # transform to bytes
    ip_header_length = ip_header_length * 4
    # skip ip header
    data = data[ip_header_length:]
    return data[0]


def traceroute(ip, port=None):
    '''Functie care are ca scop afisarea locatiilor geografice
    de pe rutele pachetelor.
    '''

    if port == None:
      # set port to a random not frequently used port
      port = randint(33434, 33513)

    #socket de UDP
    udp_send_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, \
        proto=socket.IPPROTO_UDP)

    # socket RAW de citire a răspunsurilor ICMP
    icmp_recv_socket = socket.socket(socket.AF_INET, socket.SOCK_RAW, \
        socket.IPPROTO_ICMP)

    # setam timout in cazul in care socketul ICMP la apelul recvfrom
    # nu primeste nimic in buffer
    icmp_recv_socket.settimeout(0.2)

    ttl = 1
    status = None

    while ttl <= MAX_HOPS and status != 'DESTINATION_UNREACHABLE':
        # setam TTL in headerul de IP pentru socketul de UDP
        udp_send_sock.setsockopt(socket.IPPROTO_IP, socket.IP_TTL, ttl)
        # trimite un mesaj UDP catre un tuplu (IP, port)
        udp_send_sock.sendto(b'bananabread', (ip, port))

        address = None
        try:
            data, address = icmp_recv_socket.recvfrom(65536)
            icmp_type = get_icmp_type(data)

            if icmp_type == 11:
              status = 'TTL_EXCEEDED'
            elif icmp_type == 3:
              status = 'DESTINATION_UNREACHABLE'

        except socket.error:
            status = 'SOCKET_TIMEOUT'

        finally:
            if address:
                reached_ip, _ = address
                city, region, country = get_location_info(reached_ip)
                print(f'{ttl} -> {reached_ip} | {city} | {region} | {country}')
            else:
                print(f'{ttl} -> * * *')

        ttl += 1

    udp_send_sock.close()
    icmp_recv_socket.close()


if __name__ == '__main__':
  if len(argv) != 2:
    print(f'Exactly one argument required, but {len(argv) - 1} provided')
    exit(-1)

  traceroute(argv[1])
