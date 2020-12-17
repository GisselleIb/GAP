import beeColony
import worker
import random
import tables
## Main module, constructs the matrix and the Bee Colony and then runs the
## heuristic with the given database, seeds, and iterations.
when isMainModule:

  var
    colony:BeeColony[200]
    matrix:Matrix[200,75]
    seeds:seq[int]

  randomize()#100
  matrix.initMatrix(200,75,"db/gap2.db")
  colony.initColony(200,75,200,50,matrix)
  for i in countup(1,200):
    randomize(i)
    colony.beeColonyOpt(matrix)
    echo "Best Solution: ",colony.bestSolution.cost
    if colony.bestSolution.feasible():
      seeds.add(i)
    colony.initColony(200,75,200,50,matrix)

  echo seeds


  #for w in pairs(colony.bestSolution.workers):
  #  echo w
