import random
import solution
import tables
import worker

type
  Status* = enum
    dancer=0, loner=1, follower=2

  Bee* =object
    solution*:Solution
    status*:Status


proc initBee*(workers:Table[int,Worker],tasks:seq[int],numWorkers:int,m:Matrix):Bee=
  var
    b:Bee

  b.solution=initSolution(workers,numWorkers,tasks,m,random=false)
  b.status=loner

  return b


proc loyalty(b:Bee,min,max:float):float=
  return (b.solution.cost-min)/(max-min)


proc changeStatus*(b:var Bee,min,max:float)=
  var
    p1:float=rand(1.0)
    p2:float=rand(1.0)
    loyalty:float=b.loyalty(min,max)
  #echo "Costo sol: ",b.solution.cost
  #echo "Min max: ",min, " ", max
  #echo "Loyalty: ", loyalty
  #echo p1, " ", p2

  if p1 < loyalty:
    b.status=follower
  elif p1 < p2 and p2 < loyalty:
    b.status=loner
  else:
    b.status=dancer
