# Problema 2 - Stefan-Octavian Radu - 234 - 2

points = []
# citesc punctele
with open('input', 'r') as f:
  lines = f.readlines()
  n = int(lines[0])
  for i in range(1, n + 1):
    a, b = (int(x) for x in lines[i].split())
    points.append((a, b))


def check_monoton_x(points):

  inf = float('inf')
  start = -1, (inf, inf)

  # caut cel mai din stanga (la egalitate cel mai de jos) punct
  for i, (a, b) in enumerate(points):
    if (a < start[1][0]):
      start = i, (a, b)
    elif a == start[1][0] and b < start[1][1]:
      start = i, (a, b)

  # realizez o rotire circulara a listei a.i. acel punct sa fie primul
  points = points[start[0]:] + points[:start[0]]
  points.append(points[0])

  order = 'increasing'

  last = start[1][0]
  # verific daca exista vero inconsistenta in ordine
  for a, _ in points:
    if a > last and order == 'decreasing':
      print('Poligonul nu este x-monoton.')
      return

    if a < last and order == 'increasing':
      order = 'decreasing'

    last = a

  print('Poligonul nu este x-monoton.')


def check_monoton_y(points):

  # asemanator cu rezolvarea pentru x-monotonie
  inf = float('inf')
  start = -1, (inf, inf)

  for i, (a, b) in enumerate(points):
    if (b < start[1][1]):
      start = i, (a, b)
    elif b == start[1][1] and a < start[1][0]:
      start = i, (a, b)

  points = points[start[0]:] + points[:start[0]]
  points.append(points[0])

  order = 'increasing'

  last = start[1][1]
  for _, b in points:
    if b > last and order == 'decreasing':
      print('Poligonul nu este y-monoton.')
      return

    if b < last and order == 'increasing':
      order = 'decreasing'

    last = b

  print('Pligonul este y-monoton.')


check_monoton_x(points)
check_monoton_y(points)
