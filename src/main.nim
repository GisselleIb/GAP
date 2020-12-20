import os
import strutils
import sequtils
import beeColony
import worker
import random
import tables
## Main module, constructs the matrix and the Bee Colony and then runs the
## heuristic with the given database, seeds, and iterations.
when isMainModule:
  var
    params:seq[string]=commandLineParams()
    #costs:seq[tuple[cost:float,id:int]]
    sds:seq[string]
    seeds:seq[int]

  sds=split(strip(params[1],chars={'[',']',' '}),',')
  seeds=map(sds,parseInt)

  if params[0] == "db/gap3.db":
    var
      colony:BeeColony[60]
      matrix:Matrix[50,20]
    matrix.initMatrix(50,20,params[0])
    colony.initColony(60,20,50,20,params[0],matrix)
    for i in seeds:
      randomize(i)
      colony.beeColonyOpt(matrix)
      echo "Best Solution: ",colony.bestSolution.cost
      echo "Worst Solution: ",colony.max
      for w in pairs(colony.bestSolution.workers):
        echo w
      colony.resetColony(matrix)
  elif params[0] == "db/gap4.db":
    var
      colony:BeeColony[100]
      matrix:Matrix[100,40]
    matrix.initMatrix(100,40,params[0])
    colony.initColony(100,40,100,30,params[0],matrix)
    for i in seeds:
      randomize(i)
      colony.beeColonyOpt(matrix)
      echo "Best Solution: ",colony.bestSolution.cost
      echo "Worst Solution: ",colony.max
      for w in pairs(colony.bestSolution.workers):
        echo w
      colony.resetColony(matrix)
