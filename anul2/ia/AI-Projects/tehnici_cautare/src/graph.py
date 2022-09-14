# type: ignore
'''
  Graph interface for the
  `Mormocel's escape` problem
'''

import os

from .node import Node
from .state import State
from math import floor, sqrt

class Graph:

  def __init__(self, in_id, alg_type, input_path, output_path, no_sol, timeout):
    '''
      Parameters
      ----------
      in_id : int
        id of input
      alg_type : string
        type of algorithm used
      input_path: string
        path of the input directory
      output_path : string
        path of the output directory
      no_sol : int
        number of solutions to be found
      timeout : int
        timeout threshold in seconds
    '''

    self.input_path = f'{input_path}/input_{in_id}'
    self.output_path = f'{output_path}/{alg_type}/output_{in_id}'
    self.no_sol = no_sol
    self.timeout = timeout # in seconds

    if not os.path.isfile(self.input_path):
      print('invalid input path')
      exit(-1)

    with open(self.input_path, 'r') as f:
      lines = f.readlines()
      self.radius = int(lines[0])
      self.initial_weight = int(lines[1])
      self.start_node = lines[2].strip()
      self.nodes = {}

      found_exit_leaf = False
      for line in lines[3:]:
        _id, x, y, ins_co, ma_we = (int(x) if i > 0 else x.strip() \
            for i, x in enumerate(line.split(), 0))

        assert isinstance(x, int)
        assert isinstance(y, int)
        assert isinstance(ma_we, int) and ma_we >= 0
        assert isinstance(ins_co, int) and ins_co >= 0

        dist = Graph.GetDist((x, y), (0, 0))
        assert dist < self.radius
        if self.radius - dist <= ma_we // 3: found_exit_leaf = True

        self.nodes[_id] = Node(_id, x, y, ins_co, ma_we)

      assert self.start_node in self.nodes
      if not found_exit_leaf: print(f'No solutions for input {in_id}')

      self.heuristics = [self.zero_heuristic, self.trivial_heuristic, \
                         self.admissible_heuristic1, self.admissible_heuristic2, \
                         self.inadmissible_heuristic]


  def zero_heuristic(self, state: State):
    ''' basically nothing '''
    return 0


  def trivial_heuristic(self, state: State):
    ''' final state -> good else nothing '''
    return 0 if self.is_final_state(state) else 1


  def admissible_heuristic1(self, state: State):
    ''' manhattan distance from node to edge '''
    dist = Graph.GetDist(state.node.coord, (0, 0))
    return max(0, self.radius - dist)


  def admissible_heuristic2(self, state: State):
    ''' euclidian distance from node to edge '''
    dist = Graph.GetEuclidianDist(state.node.coord, (0, 0))
    return max(0, self.radius - dist)


  def inadmissible_heuristic(self, state: State):
    ''' distance from the center '''
    return Graph.GetDist(state.node.coord, (0, 0))


  def run(self, heuristic):
    ''' to be overriden with in subclasses '''
    pass


  def output_solutions(self, solutions, runtime, max_states, \
                       total_states, heuristic=''):
    ''' Write solution report in output file
      Parameters
      ----------
      solutions: list[State]
        list of solutions found
      runtime: int
        runtime in seconds
      max_states: int
        nr of states max at a time in memory
      total_states: int
        total nr of states processed
      heuristic: string
        name of heuristic used
    '''

    with open('aggregate.txt', 'a') as f:
      # used for easier aggregation of data
      pasi, lungime = 'N/A', 'N/A'
      if len(solutions):
        states = solutions[0].get_state_path()
        pasi = len(states)
        lungime = states[-1].dist

      spl = self.output_path.split("/")
      in_id = spl[-1].split('_')[-1]
      alg = spl[-2]

      out = f'{in_id} {alg} {heuristic or "-"} ' \
        f'{(runtime * 1000):0.6f}ms {pasi} {lungime} {max_states} {total_states}\n'
      f.write(out)

    with open(self.output_path + ('' if not heuristic \
                                  else f'_{heuristic}'), 'w') as f:
      f.write(f'Found {len(solutions)} / {self.no_sol} solutions\n')
      if runtime > self.timeout:
        f.write(f'Timed out after {runtime:.6f} seconds.\n')
      else:
        f.write(f'Finished after {runtime:.6f} seconds.\n')

      f.write(f'Maximum states at one time in memory: {max_states}\n')
      f.write(f'Total states loaded in memory: {total_states}\n\n')

      for i, solution in enumerate(solutions, 1):
        states = solution.get_state_path()
        out = f'{"-" * 21} {i} {"-" * 21}\n'
        len_first_line = len(out)
        out += f'Distanta sarita: {states[-1].dist}\n'

        for j, state in enumerate(states, 0):
          out += f'{j + 1}) Broscuta '
          if j == 0:
            out += f'se afla pe frunza initiala {state.node._id}' \
              f'{state.node.coord}.\n'
          elif j < len(states):
            prev = states[j - 1]
            out += f'a sarit de la {prev.node._id} {prev.node.coord} ' \
              f'la {state.node._id} {state.node.coord}.\n' \
              f'Broscuta a mancat {state.eaten_insects} insecte. '
          out += f'Greutate broscuta: {state.weight}\n'

        total_steps = len(states)
        out += f'{total_steps + 1}) Broscuta a ajuns la mal '\
          f'in {total_steps} sarituri.\n'
        out += '-' * (len_first_line - 1) + '\n\n'
        f.write(out)


  @staticmethod
  def GetDist(point_a, point_b):
    ''' manhatan distance between two points
      Parameters
      ----------
      point_a: tuple(int, int)
      point_b: tuple(int, int)

      Return
      ------
      int
        manhatan distance between the two points
    '''
    x1, y1 = point_a
    x2, y2 = point_b
    return abs(x1 - x2) + abs(y1 - y2)


  @staticmethod
  def GetEuclidianDist(point_a, point_b):
    ''' euclidian distance between two points
      Parameters
      ----------
      point_a: tuple(int, int)
      point_b: tuple(int, int)

      Return
      ------
      int
        euclidian distance between the two points
    '''
    x1, y1 = point_a
    x2, y2 = point_b
    return sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)


  def is_final_state(self, state: State):
    ''' is final if the frog can jump outside
      Parameters
      ----------
      state: State
        state to be checked

      Returns
      -------
      bool
        whether or not the state is final
    '''
    max_jump = floor(state.weight / 3)
    dist_from_center = Graph.GetDist(state.node.coord, (0, 0))
    return dist_from_center + max_jump >= self.radius


  def neighbors(self, current_node, weight, prev_node = None):
    ''' generator of neighbors of that can be reached with given weight
      Parameters
      ----------
      current_node: Node
        the node of which neighbors to find
      weight: int
        weight of frog now
      prev_node: Node, optional
        node before

      Yields
      ------
        neighbors of current node
    '''

    max_jump, neighbors = floor(weight / 3), []

    for node in self.nodes.values():
      if node is current_node or node is prev_node:
        continue

      dist = Graph.GetDist(current_node.coord, node.coord)
      if dist > max_jump:
        continue

      yield(node)


  def next_states(self, current_state, heuristic):
    ''' generator of new states that can be reached
      Parameters
      ----------
      current_state: State
        state to be extended
      heuristic: function
        the heuristic function

      Yields
      ------
        states extend from the current one
    '''
    current_node = current_state.node
    current_weight = current_state.weight
    path = set(current_state.get_node_path())

    for neigh in self.neighbors(current_node, current_weight):
      if neigh in path or current_weight - 1 > neigh.max_weight:
        continue

      weight_buffer = neigh.max_weight - (current_weight - 1)
      max_can_eat = min(neigh.insect_count, weight_buffer)

      dist = Graph.GetDist(current_state.node.coord, neigh.coord)
      next_dist = current_state.dist + dist
      next_cost = next_dist

      for insect_count in range(max_can_eat + 1):
        next_weight = current_weight - 1 + insect_count
        next_state = State(neigh, next_weight, current_state, \
                          insect_count, next_cost, next_dist)
        next_state.cost += heuristic(next_state)
        yield next_state


  @staticmethod
  def PrintPath(last_transition):
    ''' print path '''
    last_transition.print_path()
