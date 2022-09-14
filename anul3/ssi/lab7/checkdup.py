with open("output.txt", "r") as f:
  lines = f.readlines()[1:]
  le = len(lines)
  s = set()
  for l in lines:
    ha = l.split(" ::::: ")[-1]
    s.add(ha)

  if le != len(s):
    print("coliziune")
  else:
    print("no coliziune")
