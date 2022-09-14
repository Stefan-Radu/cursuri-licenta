
K = 24
S = [4, 8, 6, 2, 11]

'''
found_sum[i] =
  True daca am putut compune suma respectiva in vreun fel
  False in caz contrar

Initial consider ca am putut obtine doar suma 0
'''

found_sum = [True] + [False for i in range(K)]

'''
Incerc sa extind pe rand toate sumele posiblie
cu fiecare element din S
'''
for elem in S:
  for j in range(K - elem, -1, -1):
    if found_sum[j]:
      found_sum[j + elem] = True

'''
Solutia este cea mai mare suma pe care am putut-o obtine
'''
sol = -1
for j in range(K, 0, -1):
  if found_sum[j]:
    sol = j
    break

'''
Complexitatea: O(len(S) * K) | Memorie: O(K)
'''

print(sol)
