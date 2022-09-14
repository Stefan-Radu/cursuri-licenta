
K, sol = int(input()), 0

while True:
  try:
    val = int(input())
    if sol + val <= K:
      sol += val
      '''
      daca intra doar aici, atunci se insumeaza tot
      deci solutia e optima
      '''
    elif sol < val:
      sol = val
      '''
      daca intra aici avem urmatoarea situatie:
      sol + val > K => 2 * max(val, sol) > K => max(val, sol) > K / 2
      cum vom continua cu maximul dintre sol si val,
      e clar ca solutia finala e cel putin jumatate din K,
      deci cel putin jumatate din solutia optima.
      '''
  except EOFError:
    break

print(sol)
