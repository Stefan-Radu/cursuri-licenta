'''
  State class for `Mormocel's escape' problem
'''

from .node import Node


class State:

  def __init__(self, node: Node, weight: int = 0, \
               prev_state: 'State' = None, eaten_insects: int = 0, \
               cost: int = 0, dist: int = 0):
    '''
      Parameters
      ----------
      node : Node
        Node corresponding to this state
      weight : int, optional
        weight of frog in this state
      prev_state : State, optional
        the state before this one
      eaten_insects : int, optional
        insects eaten from this leaf
      cost : int, optional
        dist + heuristic. sorted asc by this
      dist : int, optional
        distance until now
    '''

    self.node = node
    # check good weight
    assert weight <= node.max_weight
    self.weight = weight
    self.prev_state = prev_state
    self.eaten_insects = eaten_insects
    self.cost = cost
    self.dist = dist


  def get_state_path(self):
    ''' get path of states '''
    path, transition = [], self
    while transition is not None:
      path.append(transition)
      transition = transition.prev_state
    return path[::-1]


  def get_node_path(self):
    ''' get path of nodes '''
    path, transition = [], self
    while transition is not None:
      path.append(transition.node)
      transition = transition.prev_state
    return path[::-1]


  def __lt__(self, other: 'State') -> bool:
    ''' overload < to more easily use in priority queue
      Parameters
      ----------
      other : State
        state to compare with
    '''
    if self.cost == other.cost:
      return self.node._id < other.node._id
    return self.cost < other.cost


  def __str__(self):
    return f'node: {self.node._id}, weight: {self.weight}, ' \
      f'eaten_insects: {self.eaten_insects}, cost: {self.cost} ' \
      f'distance jumped: {self.dist}'


  def __repr__(self):
    return str(self)
