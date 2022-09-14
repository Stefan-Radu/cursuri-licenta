
INF = float('inf')

with open("input", "r") as f:
  lines = f.readlines()

  planes = []

  for line in lines:
    tup = tuple(int(x) for x in line.strip().split())
    planes.append(tup)

  margins = [[-INF, INF], [-INF, INF]]

  for a, b, c in planes:
    if b == 0:
      if a > 0:
        margins[0][1] = min(margins[0][1], - c / a)
      else:
        margins[0][0] = max(margins[0][0], - c / a)
    else:
      if b > 0:
        margins[1][1] = min(margins[1][1], - c / b)
      else:
        margins[1][0] = max(margins[1][0], c / b)

  if margins[0][0] >= margins[0][1] or margins[1][0] >= margins[1][1]:
    print("intersectia este vida")
  elif margins[0][0] != -INF and margins[1][0] != INF and \
      margins[1][0] != -INF and margins[1][1] != INF:
    print("intersectie este nevida & marginita")
  else:
    print("intersectia este nevida & nemarginita")
