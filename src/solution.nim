import random
import worker
import sequtils
import tables

type
  Solution* =object
    workers*: Table[int,Worker]
    numWorkers:int
    tasksLeft*:seq[int]
    cost*:float

proc addTaskToWorker*(s:var Solution,m:Matrix)=
  var
    id:int=rand(1..len(s.workers))
    t:int=sample(s.tasksLeft) #posible optimizacion
    cost:float
    i:int

  cost=m.costs[t][id].cost
  s.workers[id].addTask(m,t)
  if s.workers[id].excessCapacity():
    s.cost=s.cost+1000*(cost)
  else:
    s.cost=s.cost+cost

  i=s.tasksLeft.find(t)
  s.tasksLeft.delete(i)


proc initSolution*(workers:Table[int,Worker],size:int,tasks:seq[int],m:Matrix,random:bool=true):Solution=
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


proc getCost(s:Solution,m:Matrix):float=
  var
    result=0.0
  for w in s.workers:
    for t in w.tasks:
      result=result+m.costs[t][w].cost

    return result
