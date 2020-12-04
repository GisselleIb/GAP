import db_sqlite

proc getCosts*(db:string):seq[seq[string]]=
  let bd=open(db,"","","")
  result=bd.getAllRows(sql"SELECT costo FROM costos" )
  bd.close()
  return result

proc getCapacities*(db:string):seq[seq[string]]=
  let bd=open(db,"","","")
  result=bd.getAllRows(sql"SELECT capacidad FROM capacidades" )
  bd.close()
  return result

proc getWorkers*(db:string):seq[seq[string]]=
  let db=open(db,"","","")
  result=db.getAllRows(sql"SELECT id,capacidad FROM trabajadores")
  db.close()
  return result
