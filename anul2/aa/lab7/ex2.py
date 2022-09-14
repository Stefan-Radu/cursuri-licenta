# Stefan-Octavian Radu - 234.2 - ex2

with open("input", "r") as f:
  lines = f.readlines()
  q = tuple(float(x) for x in lines[0].strip().split())

  # imi tin dreptele in 4 categorii
  dr_min, st_max, sus_min, jos_max = [], [], [], []

  for line in lines[1:]:
    a, b, c = tuple(float(x) for x in line.strip().split())

    if a == 0:
      # orizontala
      if b >= 0 and (-c / b) >= q[1]:
        sus_min.append(-c / b)
      elif b < 0 and (-c / b) <= q[1]:
        jos_max.append(-c / b)
    elif b == 0:
      # verticala
      if a >= 0 and (-c / a) >= q[0]:
        dr_min.append(-c / a)
      elif a < 0 and (-c / a) <= q[0]:
        st_max.append(-c / a)

  if len(dr_min) * len(st_max) * len(sus_min) * len(jos_max) == 0:
    print('nu exista un dreptunghi cu proprietatea ceruta')
  else:
    aria = abs(min(dr_min) - max(st_max)) * \
          abs(min(sus_min) - max(jos_max))
    print('exista un dreptunghi cu proprietatea ceruta')
    print('valoare minima a ariilor dreptunghiurilor' \
          f'cu proprietatea ceruta este {aria}')


# TESTS
# 1.5 -4
# -1 0 1
# 1 0 -2
# 0 1 3
#
# 0 0
# -1 0 1
# 1 0 -2
# 0 1 3
# 0 -2 -8
#
# 1.25 -3.5
# -1 0 1
# 1 0 -2
# 0 1 3
# 0 -2 -8
#
# 2 1
# -1 0 -1
# 0 -3 -6
# 0 2 -6
# 1 0 -3
# 0 1 -2
# 2 0 -10
# 0 -1 -3
# -4 0 0
# -1 0 1
# 0 -1 -1
# 1 0 -4
