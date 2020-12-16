import beeColony
import worker
import random
import tables

when isMainModule:

  var
    colony:BeeColony[10]
    matrix:Matrix[200,75]

  randomize(9)#100
  matrix.initMatrix(200,75,"db/gap2.db")
  new(colony)
  colony.initColony(100,75,200,50,matrix)
  colony.beeColonyOpt(matrix)
  echo colony.bestSolution.cost

  for w in pairs(colony.bestSolution.workers):
    echo w
