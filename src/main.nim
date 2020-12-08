import beeColony
import worker
import random

when isMainModule:

  var
    colony:BeeColony[800]
    matrix:Matrix[1000,500]

  randomize(8)
  matrix.initMatrix(1000,500,"src/gap.db")
  new(colony)
  colony.initColony(1000,matrix)
  colony.beeColonyOpt(matrix,1000)
  echo colony.bestSolution
