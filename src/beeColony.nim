import bee
import worker
import solution
import random

type
  BeeColony*[size:static[int]] =object
    bees*:array[size,Bee]
    bestSolution*:Solution
    iterations*:int

proc forwardPass(bc:var BeeColony,m:Matrix)=
  for b in bc.bees:
    b.solution.addTaskToWorker(m)


proc backwardPass(bc: var BeeColony,m:Matrix)=
  var
    dancers:seq[Bee]
    followers:seq[Bee]
    total:float=bc.totalCost()

  for b in bc.bees:
    b.changeStatus(total)
    if b.status == dancer:
      dancers.add(b)
    elif b.status == follower:
      followers.add(b)

  for b in followers:
    var dancer=sample(dancers)
    b.solution=dancer.solution #se cambia la solución


proc totalCost(bc:BeeColony)=
  var
    total:float=0.0

  for b in bc.bees:
    total=total+b.solution.cost

  return total
