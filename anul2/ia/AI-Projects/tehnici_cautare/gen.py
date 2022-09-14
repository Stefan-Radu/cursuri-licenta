from random import randint as rand
from random import random

radius = 10
leaf_count = 50
initial_weight = 7
start_node = 'id0'

print(radius)
print(initial_weight)
print(start_node)

for l in range(leaf_count):
  id_node = f'id{l}'
  dist = rand(0, radius)
  x = rand(0, dist)
  y = dist - x
  if random() < 0.5: x *= -1
  if random() < 0.5: y *= -1
  ins_count = rand(0, radius)
  ma_we = rand(0, radius)
  print(id_node, x, y, ins_count, ma_we)
