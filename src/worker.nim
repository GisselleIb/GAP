import sqlGAP
import strutils

type
  Worker* = object
    id:int
    totalCapacity*:float
    capacity*:float
    tasks:seq[int]

  Matrix*[n,m:static[int]]=object
    dim* : tuple[N:int,M:int]
    costs* :ref array[1..n,array[1..m,tuple[capacity:float,cost:float]]]

proc initWorker*(id:int,capacity:float,tasks:seq[int]= @[]):Worker=
  var
    w:Worker
  w.id=id
  w.totalCapacity=capacity

  if len(tasks) == 0 :
    w.tasks=tasks

  return w

proc initMatrix*(matrix:Matrix,n,m:int,db:string):Matrix=
  var
    matrix=matrix
    costs=getCosts(db)
    capacities=getCapacities(db)

  new(matrix.costs)
  matrix.dim=(n,m)

  for i in countup(1,n):
    for j in countup(1,m):
      var
        capacity=parseFloat(capacities[((i-1)*m)+j-1][0])
        cost=parseFloat(costs[((i-1)*m)+j-1][0])
      matrix.costs[i][j]=(capacity,cost)

  return matrix

proc addTask(w:var Worker,m:Matrix,task:int)=
  w.tasks.add(task)
  w.capacity=w.capacity+m.costs[task][w.id].capacity

proc capacityLeft(w:Worker,m:Matrix):int=
  var
    w=w
    cl:int=0

  for t in w.tasks:
      cl=cl+m[t][w.id]

  return cl
