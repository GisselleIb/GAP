import bee
import worker
import solution
import random
import sequtils
import tables

type
  BeeColony*[size:static[int]] = ref object
    bees*:array[size,Bee]
    bestSolution*:Solution
    iterations*:int

proc initColony*(colony:var BeeColony,iterations:int,m:Matrix)=
  var
    workers:Table[int,Worker]
    tasks:seq[int]

  tasks=toSeq(1..1000)
  workers=groupWorkers("src/gap.db",tasks)
  colony.iterations=iterations
  colony.bestSolution=initSolution(workers,tasks,m)

  for i in countup(0,len(colony.bees)-1):
    colony.bees[i]=initBee(workers,tasks,m)


proc totalCost(colony:BeeColony):float=
  var
    total:float
  for b in colony.bees:
    total=total+b.solution.cost

  return total

proc getBestSolution(colony:BeeColony):Solution=
  var
    best:Solution

  best.cost=high(BiggestFloat)

  for b in colony.bees:
    if b.solution.cost < best.cost:
      best=b.solution

  return best


proc forwardPass(colony: var BeeColony,m:Matrix)=
  for i in countup(0,len(colony.bees)-1):
    colony.bees[i].solution.addTaskToWorker(m)


proc backwardPass(c: var BeeColony,m:Matrix)=
  var
    dancers:seq[Bee]
    followers:seq[Bee]
    total:float=c.totalCost()
    dn:Bee

  for i in countup(0,len(c.bees)-1):
    c.bees[i].changeStatus(total)
    if c.bees[i].status == dancer:
      dancers.add(c.bees[i])
    elif c.bees[i].status == follower:
      followers.add(c.bees[i])

  for j in countup(0,len(followers)-1):
    dn=sample(dancers)
    followers[j].solution=dn.solution #se cambia la solución, las abejas siguen a la que baila


proc beeColonyOpt*(colony:var BeeColony,m:Matrix,numTasks:int)=
  var
    best:Solution

  for i in countup(0,colony.iterations):
    for j in countup(1,numTasks):
      colony.forwardPass(m)
      echo j
      colony.backwardPass(m)
      echo j

    best=colony.getBestSolution()
    if best.cost < colony.bestSolution.cost:
      colony.bestSolution=best
    echo best
