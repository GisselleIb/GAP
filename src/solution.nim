import random
import worker
import sequtils

type
  Solution* =object
    workers*:seq[Worker]
    tasksLeft*:seq[int]
    cost*:float

proc addTaskToWorker(s:var Solution,m:Matrix)=
  var
    id:int=rand(len(s.workers)-1)
    t:int=sample(s.tasksLeft) #posible optimizacion
    i:int

  s.cost=s.cost-s.workers[id].capacity
  s.workers[id].addTask(m,t)
  s.cost=s.cost-s.workers[id].capacity
#  echo s.workers[id], " ", t
  i=s.tasksLeft.find(t)
  s.tasksLeft.delete(i)

proc initSolution*(workers:seq[Worker],tasks:seq[int],m:Matrix,random:bool=true):Solution=
  var
    s:Solution
    w:Worker

  s.workers=workers
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
