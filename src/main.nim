import beeColony
import worker
import random
import tables

when isMainModule:

  var
    colony:BeeColony[800]
    matrix:Matrix[200,75]

  randomize()#100
  matrix.initMatrix(200,75,"db/gap2.db")
  new(colony)
  colony.initColony(800,75,200,10,matrix)
  colony.beeColonyOpt(matrix)
  echo colony.bestSolution.cost

  for w in pairs(colony.bestSolution.workers):
    echo w
