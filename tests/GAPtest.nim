import ../src/worker
import ../src/solution
import unittest
import sequtils, sugar
import random

when isMainModule:

  suite "Test GAP":

    setup:
      var
        matrix:Matrix[1000,500]
        workers=toSeq(1..500)
        tasks=toSeq(1..100)
        #solution:initSolution(workers,tasks,matrix)


      matrix=initMatrix(matrix,1000,500,"src/gap.db")
      #echo solution
      #echo matrix

    test "Matrix construction":
      check matrix.costs[3][400] == (92.3418210607973,89.8588025957126)
      check matrix.costs[789][256] == (14.3541608840032,179.002828677168)
