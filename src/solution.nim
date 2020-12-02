import random
import worker

type
  Solution[numWorkers:static[int]] =object
    workers:array[0..numWorkers,Worker]
    tasksLeft:seq[int]
    cost:float

proc initSolution*(workers:openArray[int],tasks:seq[int],m:Matrix,random:bool=true):Solution=
  var
    s:Solution[len(workers)]

  s.workers=workers
  s.tasksLeft= tasks

  randomize(2)

  if  random:
    while s.tasksLeft != @[]:
      s.addTaskToWorker(m)

  return s


proc addTaskToWorker(s:Solution,m:Matrix)=
  var
    w:Worker=sample(s.workers)
    t:int=sample(s.tasksLeft)

  w.addTask(m,t)
  s.delete(t)

proc getCost(s:Solution,m:Matrix):float=
  var
    result=0.0
  for w in s.workers:
    for t in w.tasks:
      result=result+m.costs[t][w].cost

    return result
