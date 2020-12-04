import ../src/worker
import ../src/solution
import unittest
import sequtils
import random

when isMainModule:

  suite "Test GAP":

    setup:
      var
        matrix:Matrix[1000,500]
        tasks:seq[int]
        workers:seq[Worker]
        solution:Solution

      randomize(2)
      tasks=toSeq(1..1000)
      workers=groupWorkers("src/gap.db",tasks)
      matrix=initMatrix(matrix,1000,500,"src/gap.db")
      solution=initSolution(workers,tasks,matrix)

    test "Matrix construction":
      check matrix.costs[3][400] == (92.3418210607973,89.8588025957126)
      check matrix.costs[789][256] == (14.3541608840032,179.002828677168)

    test "Solution construction":
      check len(solution.tasksLeft) == 0
