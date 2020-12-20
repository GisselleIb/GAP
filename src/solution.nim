import random
import worker
import sequtils
import tables

##Module that defines the class and procedures for a Solution in the GAP problem.
type
  ## Type that contains the definition of a solution. It contains a variable
  ## ``workers`` that is a table with all the workers, a variable with the number
  ## of workers, a variable with a sequence of ``tasksLeft`` that indicates the
  ## tasks that have not been assign yet and a variable ``cost`` with the
  ## the total cost of the solution.
  Solution* =object
    workers*: Table[int,Worker]
    numWorkers*:int
    tasksLeft*:seq[int]
    cost*:float


proc addTaskToWorker*(s:var Solution,m:Matrix)=
  ## Add the next task in the sequence to a random ``Worker`` and eliminates
  ## the task from ``tasksLeft``
  var
    id:int=rand(1..s.numWorkers)
    t:int=s.tasksLeft[0]
    capCost=m.costs[t][id]

  s.workers[id].addTask(capCost.capacity,t)

  if s.workers[id].excessCapacity():
    s.cost=s.cost+(1000*capCost.cost)
  else:
    s.cost=s.cost+capCost.cost


  s.tasksLeft.delete(0)


proc initSolution*(workers:Table[int,Worker],size:int,tasks:seq[int],m:Matrix,random:bool=true):Solution=
  ## Initialize a solution given a hash table with the workers, the number of
  ## workers and the tasks that are going to be assign to the workers.
  ## If the random parameter is passed as true, then a random solution is
  ## constructed.
  var
    s:Solution

  s.workers=workers
  s.numWorkers=size
  s.tasksLeft= tasks
  s.cost=0

  if  random:
    while s.tasksLeft != @[]:
      s.addTaskToWorker(m)


  return s


proc resetSolution*(s:var Solution,tasks:seq[int])=
  ## Resets a solution to a solution that does not have any task assign to
  ## any worker, so the cost is returned to 0.
  s.tasksLeft=tasks
  s.cost=0.0
  for i in countup(1,s.numWorkers):
    s.workers[i].resetWorker()


proc getCost*(s: Solution,m:Matrix)=
  var cost=0.0
  for w in pairs(s.workers):
    for t in w[1].tasks:
      cost=cost+m.costs[t][w[0]]

  return cost
