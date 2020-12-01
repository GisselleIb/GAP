import ../src/worker
import unittest

when isMainModule:

  suite "Test GAP":

    setup:
      var
        matrix=initMatrix(1000,500,"src/gap.sql")
      echo matrix

      test "Matrix construction"
