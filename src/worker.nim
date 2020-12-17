import sqlGAP
import strutils
import tables

## Module that defines the class and procedures for a worker in the problem and
## the matrix that contains the capacities and costs for every task with each worker
type
  ## Type that contains the definition of a worker. It contains an atribute  ``totalCapacity``
  ## that indicates the amount of capacity the worker can handle, an atribute ``capacity``
  ## that indicates how much of the capacity has been wasted, a list of ``tasks``
  ## that indicates the tasks that have been assign to the worker.
  Worker* = object
    totalCapacity*:float
    capacity*:float
    tasks*:seq[int]
    numTasks*:int


  Matrix*[n,m:static[int]]=ref object
    dim* : tuple[N:int,M:int]
    costs* :array[1..n,array[1..m,tuple[capacity:float,cost:float]]]



proc initWorker*(capacity:float,tasks:seq[int]= @[]):Worker=
  ## Initialize the worker with the ``totalCapacity`` it can handle, the ``tasks``
  ## empty and the ``numTasks`` to 0 (since there are no tasks assign yet).
  var
    w:Worker

  w.totalCapacity=capacity
  w.tasks=tasks
  w.numTasks=0

  return w


proc groupWorkers*(db:string,tasks:seq[int]):Table[int,Worker]=
  ## Obtains all the workers from the ``db`` and creates a *Table* of *Worker*
  ## with the key value being the id of the worker.
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
  ## Initialize the matrix given the name of a ``db`` and the number of tasks (rows)
  ## and workers (columns). The matrix contains the capacities and costs for
  ## each worker given a task.
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
  ## Adds a task to the ``Worker`` and adds the capacity
  ## wasted from that task to the ``capacity`` used.
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
  ## Returns if a worker has exceeded his ``totalCapacity``
  return w.capacity > w.totalCapacity

proc resetWorker*(w:var Worker)=
  ## Returns the values of the ``worker`` to default.
  w.capacity=0
  w.tasks= @[]
  w.numTasks=0
