'''
  Tema 2 - Algoritmi Genetici
  Stefan Radu
  grupa 234
'''

from copy import deepcopy
from random import random, randint
from math import ceil, log2, e

POPULATION_SIZE = 50
FUNCTION_DOMAIN = (-4, 3.2)
PRECISION = 10
CROSSOVER_PROBABILITY = 0.25
MUTATION_PROBABILITY = 0.01
GENERATIONS = 50
CHROMOSOME_LENGTH = None

f = open('evolutie.txt', 'w')

def to_bin(x):
  ''' convert int to binary string with CHROMOSOME_LENGTH bits '''
  return format(x, 'b').zfill(CHROMOSOME_LENGTH)


# initialize population randomly
def initialize():
  ''' generatate random initial population '''
  global CHROMOSOME_LENGTH
  a, b = FUNCTION_DOMAIN
  CHROMOSOME_LENGTH = ceil(log2(((b - a) * 10 ** PRECISION)))
  max_value = 2 ** CHROMOSOME_LENGTH - 1
  population = [to_bin(randint(0, max_value)) for i in range(POPULATION_SIZE)]

  f.write('Populatie initiala:\n')
  for i, x in enumerate(population, 1):
    f.write(f'{i}'.rjust(3, ' ') + f': {x} | x = {decode_chromosome(x)} | ' \
            f'f = {foo(decode_chromosome(x))}\n')

  return population


def foo(x):
  ''' function to maximize '''
  # return x ** 3 + 2 * x ** 2 - x + 2
  # return x + 8
  # return (x ** 2 * e ** (-x))
  return x**3 + 3 * x**2 - 4 * x + 7


def fitness(x):
  ''' fitness function '''
  return foo(x)


def decode_chromosome(chrom):
  ''' get integer coresponding to a chromosome '''
  a, b = FUNCTION_DOMAIN
  return (b - a) / (2 ** CHROMOSOME_LENGTH) * int(chrom, 2) + a


def bisect_left(x, li):
  ''' get index where to insert x in the sorted list li '''
  st, dr, i = 0, len(li) - 1, 0

  while st <= dr:
    mid = (st + dr) // 2
    if x >= li[mid]:
      i = mid
      st = mid + 1
    else:
      dr = mid - 1

  return i


def proportional_selection(population, to_print):
  ''' russian rulette method to select next population '''

  # compute total sum of f(x) for every x over population
  foo_sum = sum(map(lambda x: fitness(decode_chromosome(x)), population))

  # compute the cummulative probabilities for each chromosome
  probabilities = [fitness(decode_chromosome(x)) / foo_sum for x in population]

  if to_print:
    f.write('\nProbabilitati selectie\n')
    for i, p in enumerate(probabilities, 1):
      f.write(f'{i}'.rjust(3, ' ') + f': probabilitate {p}\n')

  for i in range(1, len(probabilities)):
    probabilities[i] += probabilities[i - 1]

  if to_print:
    f.write('\nIntervale probabilitati selectie\n')
    f.write('0'.rjust(3, ' ') + ': cumulare 0\n')
    for i, p in enumerate(probabilities, 1):
      f.write(f'{i}'.rjust(3, ' ') + f': cumulare {p}\n')

  # russian rulette
  if to_print:
    f.write('\nSelectare\n')

  selected = []
  for i in range(POPULATION_SIZE):
    rand1 = random()
    rand2 = random()
    index1 = bisect_left(rand1, probabilities)
    index2 = bisect_left(rand2, probabilities)
    val1 =  foo(decode_chromosome(population[index1]))
    val2 =  foo(decode_chromosome(population[index2]))
    if val1 > val2:
      selected.append(deepcopy(population[index1]))
    else:
      selected.append(deepcopy(population[index2]))

    if to_print:
      pass
      # f.write(f'u = {rand} -> selectam cromozomul {index + 1}\n')

  if to_print:
    f.write('\nDupa selectie\n')
    for i, x in enumerate(selected, 1):
      f.write(f'{i}'.rjust(3, ' ') + f': {x} | x = {decode_chromosome(x)} | ' \
              f'f = {foo(decode_chromosome(x))}\n')

  return selected


def two_way_crossover(a, b, to_print):
  ''' cross two individuals '''
  split = randint(0, len(a))
  if to_print:
    f.write(f'punct {split}\n')
  return a[:split] + b[split:], \
         b[:split] + a[split:]


def three_way_crossover(a, b, c, to_print):
  ''' cross three individuals '''
  split = randint(0, len(a))
  if to_print:
    f.write(f'punct {split}\n')
  return a[:split] + b[split:], \
         b[:split] + c[split:], \
         c[:split] + a[split:], \


def crossover(population, to_print):
  ''' apply crossover to this population '''
  to_crossover, crossed_over = [], []

  if to_print:
    f.write(f'\nProbabilitatea de incrucisare {CROSSOVER_PROBABILITY}\n')

  for i, x in enumerate(population, 1):
    # select elements to enter crossover process
    prob = random()
    to_crossover.append((i, x)) if prob <= CROSSOVER_PROBABILITY \
      else crossed_over.append(x)

    if to_print:
      f.write(f'{i}'.rjust(3, ' ') + f': {x} | u = {prob}')
      if prob < CROSSOVER_PROBABILITY:
        f.write(f' < {CROSSOVER_PROBABILITY} -> participa')
      f.write('\n')

  if to_print:
    f.write('\n')

  while len(to_crossover) >= 2 and len(to_crossover) != 3:
    # cross pairs
    i, a = to_crossover.pop()
    j, b = to_crossover.pop()

    if to_print:
      f.write(f'Recombinare cromozomul {i} cu cromozomul {j}\n') 
      f.write(f'before {a} {b}\n')
    a, b = two_way_crossover(a, b, to_print)

    if to_print:
      f.write(f'after  {a} {b}\n')

    crossed_over.extend([a, b])

  if len(to_crossover) == 3:
    # if 3 left cross three
    i, a = to_crossover.pop()
    j, b = to_crossover.pop()
    k, c = to_crossover.pop()

    if to_print:
      f.write(f'Recombinare cromozomul {i} cu {j} si cu {k}\n') 
      f.write(f'before {a} {b} {c}\n')
    a, b, c = three_way_crossover(a, b, c, to_print)

    if to_print:
      f.write(f'after  {a} {b} {c}\n')

    crossed_over.extend([a, b, c])

  if len(to_crossover) != 0:
    # if anything left allow all
    crossed_over.extend(to_crossover)

  return crossed_over


def mutate(population, to_print):
  ''' apply mutation to chromosomes of this population '''
  if to_print:
    f.write(f'\nPosibilitate de mutatie pe fiecare cromozom {MUTATION_PROBABILITY}\n')

  mutated = []
  for i, x in enumerate(population):
    prob = random()
    if prob < MUTATION_PROBABILITY:
      index = randint(0, CHROMOSOME_LENGTH - 1)
      new_bit = '0' if x[index] == '1' else '1'
      population[i] = x[:index] + new_bit + x[index + 1:]
      mutated.append(i)

  if to_print and mutated:
    f.write('Au fost modificati cromozomii:\n')
    for x in mutated:
      f.write(f'{x} ')
    f.write('\n')

    f.write('Dupa mutatie:\n')
    for i, x in enumerate(population, 1):
      f.write(f'{i}'.rjust(3, ' ') + f': {x} | x = {decode_chromosome(x)} | ' \
              f'f = {foo(decode_chromosome(x))}\n')


def elitist(old_pop, new_pop):
  # extract maximum from past generation
  foo_old_pop = list(map(lambda x: foo(decode_chromosome(x)), old_pop))
  max_elem_index = foo_old_pop.index(max(foo_old_pop))
  # extract minimum from current generation
  foo_new_pop = list(map(lambda x: foo(decode_chromosome(x)), new_pop))
  min_elem_index = foo_new_pop.index(min(foo_new_pop))

  # replace minimum with maximum
  new_pop[min_elem_index] = old_pop[max_elem_index]


def iterate():
  # initialize population
  pop = initialize()

  for iteration in range(GENERATIONS):
    new_pop = proportional_selection(pop, iteration == 0)
    new_pop = crossover(new_pop, iteration == 0)
    mutate(new_pop, iteration == 0)
    # elitist(pop, new_pop)

    best = max(map(lambda x: foo(decode_chromosome(x)), new_pop))
    best_cr = list(filter(lambda x: foo(decode_chromosome(x)) == best, new_pop))[0]
    best_cr = decode_chromosome(best_cr)
    average = sum(map(lambda x: foo(decode_chromosome(x)), new_pop)) \
      / POPULATION_SIZE

    if iteration == 0:
      f.write('\nEvolutia maximului:\n')
    f.write(f'for cr = {best_cr} -> best = {best} | average = {average}\n')

    pop = new_pop

if __name__ == '__main__':
  iterate()
