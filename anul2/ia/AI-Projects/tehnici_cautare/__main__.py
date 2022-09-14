''' run thingies '''

import argparse

from tehnici_cautare.src.algorithms import UCSGraph, AStarGraph, \
  AStarOCGraph, IDAStar

def main():

  parser = argparse.ArgumentParser()
  parser.add_argument("input_path")
  parser.add_argument("output_path")
  parser.add_argument("-ns", nargs='?', default=1, type=int)
  parser.add_argument("-t", nargs='?', default=5, type=int)

  args = parser.parse_args()
  print(args)

  for index in range(1, 5):
    g = UCSGraph(index, 'ucs', args.input_path, args.output_path, args.ns, args.t)
    g.run()

    g = AStarGraph(index, 'a', args.input_path, args.output_path, args.ns, args.t)
    for heuristic in g.heuristics:
      g.run(heuristic)

    g = AStarOCGraph(index, 'aoc', args.input_path, args.output_path, args.ns, args.t)
    for heuristic in g.heuristics:
      g.run(heuristic)

    g = IDAStar(index, 'ida', args.input_path, args.output_path, args.ns, args.t)
    for heuristic in g.heuristics:
      g.run(heuristic)


if __name__ == '__main__':
  main()
