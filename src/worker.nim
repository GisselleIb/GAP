import sqlGAP
import strutils
import tables

type
  Worker* = object
    id:int
    totalCapacity*:float
    capacity*:float
    tasks:seq[int]

  Matrix*[n,m:static[int]]=ref object
    dim* : tuple[N:int,M:int]
    costs* :array[1..n,array[1..m,tuple[capacity:float,cost:float]]]



proc initWorker*(id:int,capacity:float,tasks:seq[int]= @[]):Worker=
  var
    w:Worker

  w.id=id
  w.totalCapacity=capacity
  w.tasks=tasks

  return w


proc groupWorkers*(db:string,tasks:seq[int]):Table[int,Worker]=
  var
    workers:Table[int,Worker]
    worksCaps:seq[seq[string]]
    id:int

  worksCaps=getWorkers(db)
  for wc in worksCaps:
    id=parseInt(wc[0])
    workers[id]=initWorker(id,parseFloat(wc[1]))

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



proc addTask*(w:var Worker,m:Matrix,task:int)=
  w.tasks.add(task)
  w.capacity=w.capacity+m.costs[task][w.id].capacity


proc excessCapacity*(w:Worker):bool=
  return w.capacity < w.totalCapacity
