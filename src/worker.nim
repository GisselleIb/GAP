import sqlGAP

type
  Worker* = object
    id:int
    capacity*:int
    tasks:seq[int]

  Matrix*[n:static[int],m:static[int]]= ref object
    dim* : tuple[N:int,M:int]
    costs* :array[1..n,array[1..m,tuple[capacity:int,cost:int]]]

proc initWorker*(id,capacity:int,tasks:seq[int]= @[]):Worker=
  var
    w:Worker
  w.id=id
  w.capacity=capacity

  if len(tasks) == 0 :
    w.tasks=tasks

  return w

proc initMatrix*(n,m:int,db:string):Matrix=
  var
    matrix:Matrix[n,m]
    costs=getCosts(db)
    capacities=getCapacities(db)
    k:int=0

  matrix.dim=(n,m)

  for i in countup(1,n):
    for j in countup(1,m):
      matrix[i][j]=(costs[((i-1)*m)+j][0],capacities[((i-1)*m)+j][0])

  return matrix

proc capacityLeft(w:Worker,m:Matrix):int=
  var
    w=w
    cl:int=0

  for t in w.tasks:
      cl=cl+m[t][w.id]

  return cl
