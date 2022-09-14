# Problema 1 - Stefan-Octavian Radu - 234 - 2

q = ()
points = []

# citesc punctele
with open('input', 'r') as f:
  lines = f.readlines()
  n = int(lines[0])
  for i in range(1, n + 1):
    a, b = (int(x) for x in lines[i].split())
    points.append((a, b))

  q = tuple(int(x) for x in lines[n + 1].split())

points.append(points[0])


# orientarea punctului p3 fata de segmentul (p1, p2)
def direction(p1, p2, p3):
  x1, y1 = p1
  x2, y2 = p2
  x3, y3 = p3

  d = x1 * y2 + x2 * y3 + x3 * y1 \
    - y1 * x2 - y2 * x3 - y3 * x1

  if d < 0:
    return -1
  elif d > 0:
    return 1
  else:
    return 0


# verifica daca p e pe (p1, p2)
def on_segment(p1, p2, p):
  return min(p1[0], p2[0]) <= p[0] <= max(p1[0], p2[0]) \
    and min(p1[1], p2[1]) <= p[1] <= max(p1[1], p2[1])


# verifica daca (p1, p2) se intersecteaza cu (p3, p4)
def intersect(s1, s2):
  p1, p2 = s1
  p3, p4 = s2
  d1 = direction(p3, p4, p1)
  d2 = direction(p3, p4, p2)
  d3 = direction(p1, p2, p3)
  d4 = direction(p1, p2, p4)

  if ((d1 > 0 and d2 < 0) or (d1 < 0 and d2 > 0)) and \
      ((d3 > 0 and d4 < 0) or (d3 < 0 and d4 > 0)):
    return 1

  if d1 == 0 and on_segment(p3, p4, p1):
    return 1
  elif d2 == 0 and on_segment(p3, p4, p2):
    return 1
  elif d3 == 0 and on_segment(p1, p2, p3):
    return 1
  elif d4 == 0 and on_segment(p1, p2, p4):
    return 1

  return 0


for p1, p2 in zip(points, points[1:]):
  if on_segment(p1, p2, q):
    print(f'Q{q} e pe latura ({p1}, {p2})')
    exit(0)

intersections_count = 0
segment = (q, (1e18, q[1]))

for p1, p2, in zip(points, points[1:]):
  intersections_count += intersect((p1, p2), segment)

if intersections_count & 1:
  print(f'Q{q} e in interior')
else:
  print(f'Q{q} e in exterior')
