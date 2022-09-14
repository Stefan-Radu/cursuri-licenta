from copy import deepcopy
from sys import argv

import json
import requests

HEADERS = {
  'accept': 'application/dns-json',
}

PARAMS = {
  'type': 'A', # A type to receive IPv4
}

URL = 'https://cloudflare-dns.com/dns-query'

def get_ip_address(domain):
  '''
    makes request to Cloudflare DoH API to get ip address of domain
  '''

  try:
    params = deepcopy(PARAMS)
    params['name'] = domain

    response = requests.get(URL, params=params, headers=HEADERS)
    response_data = json.loads(response.text)

    ipv4 = response_data['Answer'][-1]['data']

    return ipv4

  except Exception as e:
    print(f'failed with {e}')
    return None


if len(argv) != 2:
  print(f'Exactly one argument required, but {len(argv) - 1} provided')
  exit(-1)

ipv4 = get_ip_address(argv[1])
print(ipv4)
