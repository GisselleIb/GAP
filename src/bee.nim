import random
import solution
import tables
import worker

type
  Status* = enum
    dancer=0, loner=1, follower=2

  Bee* =object
    solution*:Solution
    status*:Status


proc initBee*(workers:Table[int,Worker],tasks:seq[int],m:Matrix):Bee=
  var
    b:Bee

  b.solution=initSolution(workers,tasks,m,random=false)
  b.status=loner

  return b


proc loyalty(b:Bee,totalCost:float):float=
  return b.solution.cost/totalCost


proc changeStatus*(b:var Bee,totalCost:float)=
  var
    p1:float=rand(1.0)
    p2:float=rand(1.0)
    loyalty:float=b.loyalty(totalCost)

  if p1 < loyalty:
    b.status=follower
  elif p2 < loyalty:
    b.status=loner
  else:
    b.status=dancer
