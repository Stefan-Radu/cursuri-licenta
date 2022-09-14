'''
  Implementation of each searching algorithm
'''

from .graph import Graph
from .state import State

from queue import PriorityQueue
from time import perf_counter
from typing import Callable


class UCSGraph(Graph):

  ''' UCS algorithm implementation '''

  def run(self):
    start_state = State(self.nodes[self.start_node], self.initial_weight)

    queue = PriorityQueue()
    queue.put(start_state)

    solutions = []
    max_states = 1
    total_states = 1
    target_sol_count = self.no_sol

    tic = perf_counter()

    while not queue.empty():
      toc = perf_counter()
      if toc - tic >= self.timeout or target_sol_count == 0:
        break

      current_state = queue.get()
      if self.is_final_state(current_state):
        solutions.append(current_state)
        target_sol_count -= 1
        continue

      for next_state in self.next_states(current_state, self.zero_heuristic):
        total_states += 1
        queue.put(next_state)
        toc = perf_counter()
        if toc - tic >= self.timeout or target_sol_count == 0:
          break

      max_states = max(max_states, queue.qsize())

    toc = perf_counter()
    self.output_solutions(solutions, toc - tic, max_states, total_states)


class AStarGraph(Graph):

  ''' A* algorithm implementation '''

  def run(self, heuristic):
    start_state = State(self.nodes[self.start_node], self.initial_weight)
    start_state.cost = start_state.dist + heuristic(start_state)

    queue = PriorityQueue()
    queue.put(start_state)

    solutions = []
    max_states = 1
    total_states = 1
    target_sol_count = self.no_sol

    tic = perf_counter()

    while not queue.empty():
      toc = perf_counter()
      if toc - tic >= self.timeout or target_sol_count == 0:
        break

      current_state = queue.get()
      if self.is_final_state(current_state):
        solutions.append(current_state)
        target_sol_count -= 1
        continue

      for next_state in self.next_states(current_state, heuristic):
        total_states += 1
        queue.put(next_state)
        toc = perf_counter()
        if toc - tic >= self.timeout or target_sol_count == 0:
          break

      max_states = max(max_states, queue.qsize())

    toc = perf_counter()
    self.output_solutions(solutions, toc - tic, max_states, \
                          total_states, heuristic.__name__)


class AStarOCGraph(Graph):

  ''' Optimal A* algorithm implementation '''

  def run(self, heuristic):

    start_state = State(self.nodes[self.start_node], self.initial_weight)
    start_state.cost = start_state.dist + heuristic(start_state)

    queue = PriorityQueue()
    queue.put(start_state)

    dist = { (self.start_node, start_state.weight, \
              start_state.eaten_insects): 0 }
    inqueue = { (self.start_node, start_state.weight, \
                 start_state.eaten_insects) }

    solutions = []
    max_states = 1
    total_states = 1
    inf = float('inf')
    tic = perf_counter()

    while not queue.empty():
      toc = perf_counter()
      if toc - tic >= self.timeout:
        break

      current_state = queue.get()
      inqueue.remove((current_state.node._id, current_state.weight, \
                      current_state.eaten_insects))

      if self.is_final_state(current_state):
        solutions = [current_state]
        break

      for next_state in self.next_states(current_state, heuristic):
        total_states += 1
        prev_dist_till_nxt = inf
        next_state_id = (next_state.node._id, next_state.weight, \
                         next_state.eaten_insects)
        if next_state_id in dist:
          prev_dist_till_nxt = dist[next_state_id]

        if next_state.dist < prev_dist_till_nxt:
          dist[next_state_id] = next_state.dist
          if next_state_id not in inqueue:
            queue.put(next_state)
            inqueue.add(next_state_id)

        toc = perf_counter()
        if toc - tic >= self.timeout:
          break

      max_states = max(max_states, queue.qsize())

    toc = perf_counter()
    self.output_solutions(solutions, toc - tic, max_states, \
                          total_states, heuristic.__name__)


class IDAStar(Graph):

  ''' IDA* algorithm implementation '''

  INF = float('inf')

  def __init__(self, *args, **kwargs):
    super().__init__(*args, **kwargs)
    self.max_states = 1
    self.total_states = 1
    self.states_in_mem = 0


  def search(self, state, bound, heuristic: Callable[[State], int], tic):

    self.states_in_mem += 1
    self.max_states = max(self.max_states, self.states_in_mem)

    toc = perf_counter()
    if toc - tic > self.timeout:
      return 'timeout'

    if state.cost > bound:
      return state.cost

    if self.is_final_state(state):
      return state

    min_cost = IDAStar.INF
    for next_state in self.next_states(state, heuristic):
      self.total_states += 1
      state = next_state
      ret = self.search(state, bound, heuristic, tic)

      if ret == 'timeout': return ret
      if isinstance(ret, State): return ret

      min_cost = min(min_cost, ret)
      state = state.prev_state
      toc = perf_counter()
      if toc - tic >= self.timeout:
        return 'timeout'

    self.states_in_mem -= 1
    return min_cost


  def run(self, heuristic: Callable[[State], int]):

    solutions = []
    last_state = State(self.nodes[self.start_node], self.initial_weight)
    bound = heuristic(last_state)
    tic = perf_counter()

    while True:
      ret = self.search(last_state, bound, heuristic, tic)
      if ret == 'timeout':
        break
      if isinstance(ret, State):
        solutions = [ret]
        break
      if ret == IDAStar.INF:
        break
      bound = ret

    toc = perf_counter()
    self.output_solutions(solutions, toc - tic, self.max_states, \
                          self.total_states, heuristic.__name__)
