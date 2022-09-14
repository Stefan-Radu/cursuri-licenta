#!/bin/bash

curl -L -X\
  POST 'http://ec2-3-88-187-87.compute-1.amazonaws.com/subnet'\
  --header 'Content-Type:application/json'\
  --data-raw '{"subnet": "10.189.24.0/24", "dim": [10, 10, 100]}'

curl -L -X\
  POST 'http://ec2-3-88-187-87.compute-1.amazonaws.com/subnet'\
  --header 'Content-Type:application/json'\
  --data-raw '{"subnet": "10.189.24.0/24", "dim": [10, 10, 125]}'

curl -L -X\
  POST 'http://ec2-3-88-187-87.compute-1.amazonaws.com/subnet'\
  --header 'Content-Type:application/json'\
  --data-raw '{"subnet": "10.189.24.0/24", "dim": [10, 10, 126]}'
