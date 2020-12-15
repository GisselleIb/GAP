import random
import worker
import sequtils
import tables

type
  Solution* =object
    workers*: Table[int,Worker]
    numWorkers*:int
    tasksLeft*:seq[int]
    cost*:float


proc addTaskToWorker*(s:var Solution,m:Matrix)=
  var
    id:int=rand(1..s.numWorkers)
    t:int=s.tasksLeft[0]
    capCost=m.costs[t][id]
  #echo "Before:"
  s.workers[id].addTask(capCost.capacity,t)
  #echo "costo anterior: ", s.cost, " ",capCost.cost
  if s.workers[id].excessCapacity():
    s.cost=s.cost+(200*capCost.cost)
  else:
    s.cost=s.cost+capCost.cost

  #echo "Costo nuevo: ", s.cost

  s.tasksLeft.delete(0)


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


proc resetSolution*(s:var Solution,tasks:seq[int])=
  s.tasksLeft=tasks
  s.cost=0.0
  for i in countup(1,s.numWorkers):
    s.workers[i].resetWorker()



proc swapTask*(s:var Solution,m:Matrix)=
  var
    w1,w2:int=0
    l:seq[int]
    i,j,t:int
    cap:float=0.0
    capCost:tuple[capacity:float,cost:float]

  #j=0
  #for k in 1..s.numWorkers:
  #  if s.workers[k].tasks == @[]:
  #    l.add(k)
  #    j=j+1

  #if rand(1.0) < 0.6 and j > 0:
  #  while w1 == w2 or s.workers[w1].tasks == @[]:
  #    w1=rand(1..s.numWorkers)
  #    w2=sample(l)

  #else:
  while w1 == w2 or s.workers[w1].tasks == @[]: #checar que w1 tenga tasks mejora el código esto está bien feo
    w1=rand(1..s.numWorkers)
    w2=rand(1..s.numWorkers)

  i=rand(0..(s.workers[w1].numTasks-1))
  t=s.workers[w1].tasks[i]
  capCost=m.costs[t][w1]

  #echo "costo antes de quitar el task:", s.cost, " ",capCost.cost
  #echo "Capacidades: ", s.workers[w1].capacity, " ", s.workers[w1].totalCapacity
  if s.workers[w1].excessCapacity():
    j=0
    for task in s.workers[w1].tasks:
      cap=cap+m.costs[task][w1].capacity
      echo cap
      j=j+1
      if j == i:
        break

    if cap > s.workers[w1].totalCapacity:
      s.cost=s.cost-(200*capCost.cost)
    else:
      s.cost=s.cost-capCost.cost
  else:
    s.cost=s.cost-capCost.cost
  s.workers[w1].deleteTask(capCost.capacity,i)
  #echo "costo despues de quitar el task:",s.cost

  capCost=m.costs[t][w2]
  s.workers[w2].addTask(capCost.capacity,t)
  #echo s.workers[w1].tasks, s.workers[w1].numTasks
  if s.workers[w2].excessCapacity():
    s.cost=s.cost+(200*capCost.cost)
  else:
    s.cost=s.cost+capCost.cost
