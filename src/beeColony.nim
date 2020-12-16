import bee
import worker
import solution
import random
import sequtils
import tables

type
  BeeColony*[size:static[int]] = ref object
    numBees*:int
    numWorkers:int
    numTasks:int
    iterations*:int
    bees*:array[size,Bee]
    min,max:float
    bestSolution*:Solution

proc initColony*(colony:var BeeColony,size,numWorkers,numTasks,iterations:int,m:Matrix)=
  var
    workers:Table[int,Worker]
    tasks:seq[int]

  colony.iterations=iterations
  colony.numBees=size
  colony.numWorkers=numWorkers
  colony.numTasks=numTasks
  colony.min=high(BiggestFloat)
  colony.max=0.0

  tasks=toSeq(1..numTasks)
  workers=groupWorkers("db/gap2.db",tasks)
  colony.bestSolution=initSolution(workers,numWorkers,tasks,m)

  for i in countup(0,size-1):
    colony.bees[i]=initBee(workers,tasks,numWorkers,m)

proc resetBees*(c:BeeColony)=
  var
    tasks:seq[int]=toSeq(1..c.numTasks)

  for i in countup(0,c.numBees-1):
    c.bees[i].solution.resetSolution(tasks)


proc getBestSolution(colony:BeeColony):Solution= #Se puede optimizar en el método principal
  var
    best:Solution

  best.cost=high(BiggestFloat)

  for b in colony.bees:
    #echo "Solución abeja:", b.solution.cost
    if b.solution.cost < best.cost:
      best=b.solution

  return best


proc forwardPass(colony: var BeeColony,m:Matrix,j:int)=
  colony.min=high(BiggestFloat)
  colony.max=0.0
  for i in countup(0,colony.numBees-1):
    colony.bees[i].solution.addTaskToWorker(m)
    #if j > 3:
    #colony.bees[i].solution.swapTask(m)

    if colony.bees[i].solution.cost < colony.min:
      colony.min = colony.bees[i].solution.cost

    if colony.bees[i].solution.cost > colony.max:
      colony.max=colony.bees[i].solution.cost

    #if int(j) == colony.numTasks and colony.bees[i].solution.cost < colony.bestSolution.cost:
    #  colony.bestSolution=colony.bees[i].solution


proc backwardPass(c: var BeeColony)=
  var
    dancers:seq[int]
    followers:seq[int]
    id:int

  for i in countup(0,c.numBees-1):
    c.bees[i].changeStatus(c.min,c.max)
    if c.bees[i].status == dancer:
      dancers.add(i)
    elif c.bees[i].status == follower:
      followers.add(i)
  #echo len(dancers), " ", len(followers)
  for j in followers:
    id=sample(dancers)
    #echo "Follower: ",c.bees[j].solution.cost
    #echo "Dancer: ",c.bees[id].solution.cost
    c.bees[j].solution=c.bees[id].solution


proc beeColonyOpt*(colony:var BeeColony,m:Matrix)=
  var
    best:Solution
    min,max:float

  for i in countup(1,colony.iterations):
    for j in countup(1,colony.numTasks):
      colony.forwardPass(m,j)
      colony.backwardPass()

    best=colony.getBestSolution()
    if best.cost < colony.bestSolution.cost:
      colony.bestSolution=best

    echo "Mejor solucion:",colony.bestSolution.cost
    colony.resetBees()
