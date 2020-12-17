import bee
import worker
import solution
import random
import sequtils
import tables

type
  ## Type that contains the definition of an artifitial bee colony. It contains
  ## atributes to keep track the number of bees in the colony, the number of
  ## workers in the problem, the number of tasks to be associated, the number
  ## of iterations that the algorithm is going to be executed, an array
  ## with the bees and the bestSolution that has been found in all the
  ## iterations.
  BeeColony*[size:static[int]] = ref object
    numBees*:int
    numWorkers:int
    numTasks:int
    iterations*:int
    bees*:array[size,Bee]
    min,max:float
    bestSolution*:Solution


proc initColony*(colony:var BeeColony,size,numWorkers,numTasks,iterations:int,db:string,m:Matrix)=
  ## Initialize the colony. Creates the hash table with the workers and
  ## creates as many bees as indicated in the argument size.
  var
    workers:Table[int,Worker]
    tasks:seq[int]

  new(colony)
  colony.iterations=iterations
  colony.numBees=size
  colony.numWorkers=numWorkers
  colony.numTasks=numTasks
  colony.min=high(BiggestFloat)
  colony.max=0.0

  tasks=toSeq(1..numTasks)
  workers=groupWorkers(db,tasks)
  colony.bestSolution=initSolution(workers,numWorkers,tasks,m)

  for i in countup(0,size-1):
    colony.bees[i]=initBee(workers,tasks,numWorkers,m)


proc resetBees*(c:BeeColony)=
  ## Reset each Bee so that each Bee has a solution with all the
  ## tasks to be assign and workers without tasks.
  var
    tasks:seq[int]=toSeq(1..c.numTasks)

  for i in countup(0,c.numBees-1):
    c.bees[i].solution.resetSolution(tasks)


proc getBestSolution(colony:BeeColony):Solution= #Se puede optimizar en el método principal
  ## Returns the best solution obtained by the bees.
  var
    best:Solution

  best.cost=high(BiggestFloat)

  for b in colony.bees:
    if b.solution.cost < best.cost:
      best=b.solution

  return best


proc forwardPass(colony: var BeeColony,m:Matrix,j:int)=
  ## Sends all bees to the last point where they left the construction of its
  ## solution and continues the construction by adding a task to a random worker.
  ## At the same time obtains the minimal and maximum cost in all the colony, in
  ## this phase.
  var k:int
  colony.min=high(BiggestFloat)
  colony.max=0.0

  for i in countup(0,colony.numBees-1):
    colony.bees[i].solution.addTaskToWorker(m)

    if colony.bees[i].solution.cost < colony.min:
      colony.min = colony.bees[i].solution.cost
      k=i

    if colony.bees[i].solution.cost > colony.max:
      colony.max=colony.bees[i].solution.cost


  if j == colony.numTasks and colony.min < colony.bestSolution.cost:
      colony.bestSolution=colony.bees[k].solution



proc backwardPass(c: var BeeColony)=
  ## Returns all the bees to the hive so they compare each solution and based in
  ## the cost of their solutions each bee decides if they will become a ``dancer``
  ## a ``follower`` or a ``loner``.
  ## After obtaining each status, puts all the indexes of the followers in a
  ## sequence and does the same for the dancers, then for each follower choose
  ## a random dancer and change the solution of the follower for the solution of
  ## dancer (so that it simulates that the follower follows the path of the
  ## dancer)
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

  for j in followers:
    id=sample(dancers)
    c.bees[j].solution=c.bees[id].solution


proc feasible*(s:Solution):bool=
  ## Given a solution returns if it is feasible.
  ## For a solution to be feasible it needs to have all the workers must no
  ## have its capacity bigger than its totalCapacity .
  for w in values(s.workers):
    if w.excessCapacity():
      return false

  return true

proc resetColony*(colony:var BeeColony,m:Matrix)=
  ## Resets the colony for a new execution of the algorithm
  colony.bestSolution.cost=high(BiggestFloat)


proc beeColonyOpt*(colony:var BeeColony,m:Matrix)=
  ## Executes the heuristic of the Bee Colony Optimization.
  ## It runs for the number of iterations and each iterations runs for
  ## the number of tasks to be assign (since each task is assign in each phase).
  ## For each phase executes the forwardPass and the backwardPass for the
  ## bees to construct their solution.
  ## After each iteration, gets the best solution of the colony and compares it
  ## with the best solution obtained in the past iterations.
  for i in countup(1,colony.iterations):
    for j in countup(1,colony.numTasks):
      colony.forwardPass(m,j)
      colony.backwardPass()

    colony.resetBees()
