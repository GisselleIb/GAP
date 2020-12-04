import sqlGAP
import strutils

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


proc groupWorkers*(db:string,tasks:seq[int]):seq[Worker]=
  var
    workers:seq[Worker]
    worksCaps:seq[seq[string]]

  worksCaps=getWorkers(db)
  for wc in worksCaps:
    workers.add(initWorker(parseInt(wc[0]),parseFloat(wc[1])))

  return workers


proc initMatrix*(matrix:Matrix,n,m:int,db:string):Matrix=
  var
    matrix=matrix
    costs=getCosts(db)
    capacities=getCapacities(db)

  new(matrix)
  matrix.dim=(n,m)

  for i in countup(1,n):
    var k=((i-1)*m)
    for j in countup(1,m):
      var
        capacity=parseFloat(capacities[k+j-1][0])
        cost=parseFloat(costs[k+j-1][0])
      matrix.costs[i][j]=(capacity,cost)

  return matrix


proc addTask*(w:var Worker,m:Matrix,task:int)=
  w.tasks.add(task)
  w.capacity=w.capacity+m.costs[task][w.id].capacity


proc capacityLeft(w:Worker,m:Matrix):int=
  var
    w=w
    cl:int=0

  for t in w.tasks:
      cl=cl+m[t][w.id]

  return cl
