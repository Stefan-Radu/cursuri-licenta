import copy
import math


class NodParcurgere:
    def __init__(self, info, parinte, f, g):
        self.info = info
        self.parinte = parinte  # parintele din arborele de parcurgere
        self.f = f
        self.g = g

    def obtineDrum(self):
        l = [self.info]
        nod = self
        while nod.parinte is not None:
            l.insert(0, nod.parinte.info)
            nod = nod.parinte
        return l

    def afisDrum(self):  # returneaza si lungimea drumului
        l = self.obtineDrum()
        print(("->").join([str(x) for x in l]))
        return len(l)

    def contineInDrum(self, infoNodNou):
        nodDrum = self
        while nodDrum is not None:
            if (infoNodNou == nodDrum.info):
                return True
            nodDrum = nodDrum.parinte

        return False

    def __repr__(self):
        sir = ""
        sir += self.info + "("
        sir += "drum="
        drum = self.obtineDrum()
        sir += ("->").join(drum)
        return (sir)


class Graph:  # graful problemei
    def __init__(self, start, scop):
        self.start = start
        self.scop = scop
        self.scop_coord = Graph.GetCoord(scop)
        print(self.scop_coord)


    @staticmethod
    def GetCoord(nod):
      ret = {}
      for i, stk in enumerate(nod, 1):
        for j, idd in enumerate(stk, 1):
          ret[idd] = (i, j)
      return ret


    # va genera succesorii sub forma de noduri in arborele de parcurgere
    def genereazaSuccesori(self, nodCurent):
      listaSuccesori = []
      for i, stack in enumerate(nodCurent.info):
        if len(stack) == 0:
          continue

        for j, stack in enumerate(nodCurent.info):
          if i == j:
            continue

          new_info = copy.deepcopy(nodCurent.info)
          new_info[j].append(new_info[i].pop())

          new_node = (new_info, self.calculeaza_h(new_info), nodCurent.g + 1)
          listaSuccesori.append(new_node)

      return listaSuccesori


    def calculeaza_h(self, nod_info):
      dist = 0
      coord_now = Graph.GetCoord(nod_info)
      for key, value in coord_now.items():
        a, b = value
        c, d = self.scop_coord[key]
        dist += abs(a - c) + abs(b - d)

      return dist


    def __repr__(self):
        sir = ""
        for (k, v) in self.__dict__.items():
            sir += "{} = {}\n".format(k, v)
        return (sir)


##############################################################################################
#                                 Initializare problema                                      #
##############################################################################################

# pozitia i din vector
start = [[1,2,3], [4,5,6], []]
scop = [[1,6,2], [4,5], [3]]
gr = Graph(start, scop)

def in_list(nod_info, lista):
  for nod in lista:
    if nod_info == nod.info:
      return nod
  return None


def insert(node, lista):
  idx = 0
  while idx < len(lista) - 1 and (node.f > lista[idx].f or (node.f == lista[idx].f and node.g < lista[idx].g)):
    idx += 1
  lista.insert(idx, node)


def a_star():
  #de completat
  opened = [NodParcurgere(start, None, 0, 0)]

  closed = []

  continua = True

  while continua and len(opened) > 0:
    current_node = opened.pop(0)
    closed.append(current_node)

    if current_node.info == scop:
      print(current_node.afisDrum())
      continua = False

    succesori = gr.genereazaSuccesori(current_node)
    for nod in succesori:
      info, h, g = nod
      node_open = in_list(info, opened)
      node_parc = NodParcurgere(info, current_node, g, g + h)
      if node_open is not None:
        if node_open.f > g + h:
          opened.remove(node_open)
          insert(node_parc, opened)
        continue
      node_closed = in_list(info, closed)
      if node_closed is not None:
        if node_closed.f > g + h:
          closed.remove(node_closed)
          insert(node_parc, opened)
        continue
      insert(node_parc, opened)

  if len(opened) == 0:
    print("Nu exista drum!")



if __name__ == '__main__':
    a_star()
