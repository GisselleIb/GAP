import sqlGAP
import strutils
import tables

type
  Worker* = object
    totalCapacity*:float
    capacity*:float
    tasks*:seq[int]
    numTasks*:int

  Matrix*[n,m:static[int]]=ref object
    dim* : tuple[N:int,M:int]
    costs* :array[1..n,array[1..m,tuple[capacity:float,cost:float]]]



proc initWorker*(capacity:float,tasks:seq[int]= @[]):Worker=
  var
    w:Worker

  w.totalCapacity=capacity
  w.tasks=tasks
  w.numTasks=0

  return w


proc groupWorkers*(db:string,tasks:seq[int]):Table[int,Worker]=
  var
    workers:Table[int,Worker]
    worksCaps:seq[seq[string]]
    id:int

  worksCaps=getWorkers(db)
  for wc in worksCaps:
    id=parseInt(wc[0])
    workers[id]=initWorker(parseFloat(wc[1]))

  return workers


proc initMatrix*(matrix:var Matrix,n,m:int,db:string)=
  var
    costs=getCosts(db)
    capacities=getCapacities(db)
    k:int

  new(matrix)
  matrix.dim=(n,m)

  for i in countup(1,n):
    k=((i-1)*m)
    for j in countup(1,m):
      var
        capacity=parseFloat(capacities[k+j-1][0])
        cost=parseFloat(costs[k+j-1][0])
      matrix.costs[i][j]=(capacity,cost)



proc addTask*(w:var Worker,capacity:float,task:int)=
  w.tasks.add(task)
  w.capacity=w.capacity+capacity
  #echo "Nuevas cap: ",w.capacity, " ", w.totalCapacity
  w.numTasks=w.numTasks+1


proc deleteTask*(w:var Worker,capacity:float,id:int)=
  w.tasks.delete(id)
  w.capacity=w.capacity-capacity
  #echo "Nuevas cap: ",w.capacity, " ", capacity
  w.numTasks=w.numTasks-1


proc excessCapacity*(w:Worker):bool=
  return w.capacity > w.totalCapacity

proc resetWorker*(w:var Worker)=
    w.capacity=0
    w.tasks= @[]
    w.numTasks=0
