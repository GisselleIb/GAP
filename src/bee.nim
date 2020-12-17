import solution
import tables
import worker

## Module that defines the class and procedures needed for modeling a Bee for
## the heuristic

type
  ## Enum that assigns a value for the type or *Status* of a *Bee*
  Status* = enum
    dancer=0, loner=1, follower=2

  ## Type that contains the definition of a *Bee*. It contains the ``solution``
  ## that is currently constructed by the *Bee* and the current ``status`` of the
  Bee* =object
    solution*:Solution
    status*:Status


proc initBee*(workers:Table[int,Worker],tasks:seq[int],numWorkers:int,m:Matrix):Bee=
  ## Initialize the *Bee* by creating a solution with the table of ``workers``
  ## and all the tasks that needs to be assign to each worker. By the default
  ## the *Bee* starts as a loner.
  var
    b:Bee

  b.solution=initSolution(workers,numWorkers,tasks,m,random=false)
  b.status=loner

  return b


proc loyalty(b:Bee,min,max:float):float=
  ## Calculates the loyalty of a *Bee* towards its solution.
  ## It calculates it by putting it in a range of 0-1 given by the best solution
  ## and the worst solution of the current phase. The closer the loyalty
  ## is to 0, the less is the probabilty of the bee to change its solution.
  return (b.solution.cost-min)/(max-min)


proc changeStatus*(b:var Bee,min,max:float)=
  ## Change the status of the *Bee*. If the bee has loyalty bigger than 0.2
  ## the likely the Bee has a bad solution, so it will become a ``follower`` and
  ## change its solution for the solution of a dancer.
  ## If the loyalty is bigger than 0.05 but smaller than 0.2, the bee will become
  ## a loner and continue with its own solution by itself.
  ## If the loyalty is smaller than 0.05 then the bee will become a ``dancer``
  ## and will recruit ``follower`` bees.
  var
    loyalty:float=b.loyalty(min,max)

  if loyalty > 0.2:
    b.status=follower
  elif loyalty > 0.05 :
    b.status=loner
  else:
    b.status=dancer
