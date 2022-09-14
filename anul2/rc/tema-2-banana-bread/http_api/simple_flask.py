import re
from flask import Flask, jsonify, request
from flask_api import status
from math import log2, ceil


app = Flask(__name__)


def is_ipv4_subnet(ip):
    pattern = r'([0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}'
    result = re.search(pattern, ip)
    if result:
        return result.group() == ip
    return False


def parse_range(ip_range):
    ''' primeste un ip range si intoarge range-ul
        corespunzator sub forma de intregi
    '''

    ip, mask = ip_range.strip().split('/')

    lower_bound = 0
    for i, byte in enumerate(ip.split('.')[::-1]):
        lower_bound |= (int(byte) << (8 * i))

    end_ones = (1 << (32 - int(mask))) - 1
    assert (lower_bound & end_ones) == 0
    upper_bound  = lower_bound | end_ones

    return lower_bound, upper_bound


def int_to_ipv4(number):
    ret = ''
    while number:
        ret = f'{number & 255}.' + ret
        number >>= 8
    return ret[:-1]


@app.route('/subnet', methods=['POST'])
def subnet():
    data = request.get_json()

    subnet = data.get('subnet')

    if not subnet:
        return jsonify({
            'status': 'error',
            'message': 'subnet field mandatory'
        }), status.HTTP_400_BAD_REQUEST

    if not is_ipv4_subnet(subnet):
        return jsonify({
            'status': 'error',
            'message': 'subnet field not formatted propperly'
        }), status.HTTP_400_BAD_REQUEST

    dim = data.get('dim')

    if not dim:
        return jsonify({
            'status': 'error',
            'message': 'dim field mandatory'
        }), status.HTTP_400_BAD_REQUEST

    if not isinstance(dim, list) or sum([0 if isinstance(x, int) \
                                         else 1 for x in dim]) != 0:
        return jsonify({
            'status': 'error',
            'message': 'dim field not formatted propperly'
        }), status.HTTP_400_BAD_REQUEST


    lb, ub = parse_range(subnet)

    dim = [(ceil(log2(x + 3)), i) for i, x in enumerate(dim, 1)]
    dim.sort(key=lambda x: (-x[0], x[1]))

    ret = []

    for bits, i in dim:
        mask = 32 - bits
        ub_now = lb + (1 << bits) - 1
        if ub_now > ub:
            return jsonify({
                'status': 'error',
                'message': 'range is too narrow'
            }), status.HTTP_400_BAD_REQUEST
        ret.append((f'LAN{i}', f'{int_to_ipv4(lb)}/{mask}'))
        lb = ub_now + 1

    ret.sort(key=lambda x: x[0])
    ret = {key: value for key, value in ret}

    return jsonify({
        'status': 'ok',
        'subnets': ret
    }), status.HTTP_200_OK


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
