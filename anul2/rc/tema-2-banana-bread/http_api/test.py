import unittest
import json
import requests

class TestApi(unittest.TestCase):
    url = 'http://ec2-3-88-187-87.compute-1.amazonaws.com/subnet'
    header = {'Content-Type': 'application/json'}

    def test_base(self):
        data = {'subnet': '10.189.24.0/24', 'dim': [10, 10, 100]}
        response = requests.post(self.url, headers=self.header, \
                                 data=json.dumps(data))
        ret = json.loads(response.content)
        self.assertEqual(ret['subnets'], {
            'LAN1': '10.189.24.128/28',
            'LAN2': '10.189.24.144/28',
            'LAN3': '10.189.24.0/25'})
        self.assertEqual(response.status_code, 200)


    def test_no_subnet(self):
        data = {'subnet': None, 'dim': [10, 10, 100]}
        response = requests.post(self.url, headers=self.header, \
                                 data=json.dumps(data))
        ret = json.loads(response.content)
        self.assertEqual(ret['status'], 'error')
        self.assertEqual(response.status_code, 400)


    def test_wrong_subnet(self):
        data = {'subnet': '10.10/22', 'dim': [10, 10, 100]}
        response = requests.post(self.url, headers=self.header, \
                                 data=json.dumps(data))
        ret = json.loads(response.content)
        self.assertEqual(ret['status'], 'error')
        self.assertEqual(response.status_code, 400)


    def test_no_dim(self):
        data = {'subnet': '10.189.24.0/24', 'dim': None}
        response = requests.post(self.url, headers=self.header, \
                                 data=json.dumps(data))
        ret = json.loads(response.content)
        self.assertEqual(ret['status'], 'error')
        self.assertEqual(response.status_code, 400)


    def test_wrong_dim(self):
        data = {'subnet': '10.189.24.0/24', 'dim': ['ala', 10, 100]}
        response = requests.post(self.url, headers=self.header, \
                                 data=json.dumps(data))
        ret = json.loads(response.content)
        self.assertEqual(ret['status'], 'error')
        self.assertEqual(response.status_code, 400)


    def test_cannot_split(self):
        data = {'subnet': '10.189.24.0/24', 'dim': [10, 10, 126]}
        response = requests.post(self.url, headers=self.header, \
                                 data=json.dumps(data))
        ret = json.loads(response.content)
        self.assertEqual(ret['status'], 'error')
        self.assertEqual(ret['message'], 'range is too narrow')
        self.assertEqual(response.status_code, 400)


    def test_can_split(self):
        data = {'subnet': '10.189.24.0/24', 'dim': [125, 12, 10]}
        response = requests.post(self.url, headers=self.header, \
                                 data=json.dumps(data))
        ret = json.loads(response.content)
        self.assertEqual(ret['status'], 'ok')
        self.assertEqual(response.status_code, 200)

if __name__ == '__main__':
    unittest.main()
