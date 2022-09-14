'''
  Node class for `Mormocel's escape' problem
'''

class Node:
  def __init__(self, _id, x, y, insect_count, max_weight):
    '''
      Parameters
      ----------
      _id : string
        the id of the node
      x : int
        x coordinate
      y : int
        y coordinate
      insect_count : int
        the number of insects in the node
      max_weight : int
        max frog weight allowed on the node
    '''
    self._id = _id
    self.coord = (x, y)
    self.insect_count = insect_count
    self.max_weight = max_weight


  def __str__(self):
    ''' overload pentru print '''
    header = f'------ Nod {self._id} ------\n'
    footer = '-' * (len(header) - 1) + '\n'
    return header + \
      f'coordonate: ({self.coord[0]} x {self.coord[1]})\n' \
      f'insecte: {self.insect_count}\n' \
      f'greutate maxima: {self.max_weight}\n' + \
      footer


  def __repr__(self):
    ''' overload pentru repr '''
    return str({
      '_id': self._id,
      'coord': (self.coord),
      'insects': self.insect_count,
      'max_weight': self.max_weight,
    })
